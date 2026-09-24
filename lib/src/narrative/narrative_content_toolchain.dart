import 'narrative.dart';

class NarrativeContentIssue {
  const NarrativeContentIssue(this.severity, this.code, this.path, this.message);
  final NarrativeContentSeverity severity;
  final String code;
  final String path;
  final String message;

  @override
  String toString() => '${severity.name.toUpperCase()} $code $path: $message';
}

enum NarrativeContentSeverity { error, warning }

class NarrativeContentReport {
  const NarrativeContentReport(this.issues, {
    required this.reachableNodeIds,
    required this.terminalNodeIds,
    required this.deadEndNodeIds,
    required this.cycleNodeIds,
    required this.eventTypes,
    required this.consequenceTypes,
  });

  final List<NarrativeContentIssue> issues;
  final Set<String> reachableNodeIds;
  final Set<String> terminalNodeIds;
  final Set<String> deadEndNodeIds;
  final Set<String> cycleNodeIds;
  final Set<String> eventTypes;
  final Set<String> consequenceTypes;

  bool get hasErrors => issues.any((i) => i.severity == NarrativeContentSeverity.error);
  int get errors => issues.where((i) => i.severity == NarrativeContentSeverity.error).length;
  int get warnings => issues.where((i) => i.severity == NarrativeContentSeverity.warning).length;

  Map<String, Object?> toJson() => {
    'errors': errors,
    'warnings': warnings,
    'reachableNodes': reachableNodeIds.toList()..sort(),
    'terminalNodes': terminalNodeIds.toList()..sort(),
    'deadEndNodes': deadEndNodeIds.toList()..sort(),
    'cycleNodes': cycleNodeIds.toList()..sort(),
    'eventTypes': eventTypes.toList()..sort(),
    'consequenceTypes': consequenceTypes.toList()..sort(),
    'issues': issues.map((i) => {
      'severity': i.severity.name,
      'code': i.code,
      'path': i.path,
      'message': i.message,
    }).toList(),
  };
}

/// Static content analyzer for branching narrative JSON.
/// It deliberately reasons about structure and contracts, not game-domain state.
class NarrativeContentToolchain {
  NarrativeContentReport analyze(
    NarrativeDefinition definition, {
    Set<String> knownEventTypes = const {},
    Set<String> knownConsequenceTypes = const {},
  }) {
    final issues = <NarrativeContentIssue>[];
    final nodesById = <String, NarrativeNode>{};
    final eventTypes = <String>{};
    final consequenceTypes = <String>{};

    void error(String code, String path, String message) => issues.add(
      NarrativeContentIssue(NarrativeContentSeverity.error, code, path, message),
    );
    void warning(String code, String path, String message) => issues.add(
      NarrativeContentIssue(NarrativeContentSeverity.warning, code, path, message),
    );

    for (final node in definition.nodes) {
      if (nodesById.containsKey(node.id)) {
        error('duplicate_node', 'nodes.${node.id}', 'duplicate node id');
      } else {
        nodesById[node.id] = node;
      }
      if (node.enterEventType != null) {
        eventTypes.add(node.enterEventType!);
        if (knownEventTypes.isNotEmpty && !knownEventTypes.contains(node.enterEventType)) {
          error('unknown_event', 'nodes.${node.id}.enterEventType', 'event type ${node.enterEventType} is not in the event catalog');
        }
      }
      for (final consequence in node.enterConsequences) {
        consequenceTypes.add(consequence);
        if (knownConsequenceTypes.isNotEmpty && !knownConsequenceTypes.contains(consequence)) {
          error('unknown_consequence', 'nodes.${node.id}.enterConsequences', 'consequence type $consequence is not in the vocabulary catalog');
        }
      }
      final choiceIds = <String>{};
      for (final choice in node.choices) {
        if (!choiceIds.add(choice.id)) {
          error('duplicate_choice', 'nodes.${node.id}.choices.${choice.id}', 'duplicate choice id within node');
        }
        if (!nodesById.containsKey(choice.targetNodeId) && !definition.nodes.any((n) => n.id == choice.targetNodeId)) {
          error('unknown_target', 'nodes.${node.id}.choices.${choice.id}', 'target node ${choice.targetNodeId} does not exist');
        }
        for (final consequence in choice.consequenceTypes) {
          consequenceTypes.add(consequence);
          if (knownConsequenceTypes.isNotEmpty && !knownConsequenceTypes.contains(consequence)) {
            error('unknown_consequence', 'nodes.${node.id}.choices.${choice.id}.consequences', 'consequence type $consequence is not in the vocabulary catalog');
          }
        }
        if (_conditionIsContradictory(choice.condition)) {
          warning('impossible_condition', 'nodes.${node.id}.choices.${choice.id}.condition', 'condition is structurally contradictory and can never match');
        }
      }
      if (node.autoTargetNodeId != null && !definition.nodes.any((n) => n.id == node.autoTargetNodeId)) {
        error('unknown_auto_target', 'nodes.${node.id}.autoTargetNodeId', 'target node ${node.autoTargetNodeId} does not exist');
      }
      if (node.autoTargetNodeId == node.id) {
        error('self_loop', 'nodes.${node.id}.autoTargetNodeId', 'node auto-transitions to itself');
      }
    }

    if (!nodesById.containsKey(definition.startNodeId)) {
      error('unknown_start', 'startNodeId', 'start node ${definition.startNodeId} does not exist');
    }

    final reachable = <String>{};
    final stack = <String>[definition.startNodeId];
    while (stack.isNotEmpty) {
      final id = stack.removeLast();
      if (!reachable.add(id)) continue;
      final node = nodesById[id];
      if (node == null) continue;
      if (node.autoTargetNodeId != null) stack.add(node.autoTargetNodeId!);
      for (final choice in node.choices) stack.add(choice.targetNodeId);
    }

    for (final node in definition.nodes) {
      if (!reachable.contains(node.id)) {
        error('unreachable_node', 'nodes.${node.id}', 'node cannot be reached from ${definition.startNodeId}');
      }
    }

    final terminals = definition.nodes.where((n) => n.terminal).map((n) => n.id).toSet();
    final deadEnds = <String>{};
    for (final node in definition.nodes.where(reachable.contains)) {
      if (!node.terminal && node.choices.isEmpty && node.autoTargetNodeId == null && node.enterEventType == null) {
        deadEnds.add(node.id);
        error('dead_end', 'nodes.${node.id}', 'non-terminal node has no choice, auto transition, or event gate');
      }
    }
    if (terminals.isEmpty) error('no_terminal', 'nodes', 'narrative has no terminal node');

    final cycleNodes = _findCycleNodes(nodesById, reachable);
    for (final id in cycleNodes) {
      warning('cycle', 'nodes.$id', 'node participates in a narrative graph cycle; ensure an event/state change can break it');
    }

    for (final node in definition.nodes.where(reachable.contains)) {
      if (!node.terminal && node.choices.isNotEmpty && node.choices.every((c) => _conditionIsContradictory(c.condition))) {
        error('no_available_choice', 'nodes.${node.id}.choices', 'all choices have contradictory conditions');
      }
    }

    return NarrativeContentReport(
      issues,
      reachableNodeIds: reachable,
      terminalNodeIds: terminals,
      deadEndNodeIds: deadEnds,
      cycleNodeIds: cycleNodes,
      eventTypes: eventTypes,
      consequenceTypes: consequenceTypes,
    );
  }

  bool _conditionIsContradictory(NarrativeCondition condition) {
    if (condition is ValueNarrativeCondition) {
      if (condition.equals != null && condition.greaterThan != null && condition.equals! <= condition.greaterThan!) return true;
      if (condition.equals != null && condition.lessThan != null && condition.equals! >= condition.lessThan!) return true;
      if (condition.greaterThan != null && condition.lessThan != null && condition.greaterThan! >= condition.lessThan!) return true;
    }
    if (condition is AllNarrativeCondition) return condition.children.any(_conditionIsContradictory);
    if (condition is AnyNarrativeCondition) return condition.children.isNotEmpty && condition.children.every(_conditionIsContradictory);
    if (condition is NotNarrativeCondition) return false;
    return false;
  }

  Set<String> _findCycleNodes(Map<String, NarrativeNode> nodes, Set<String> reachable) {
    final visiting = <String>{};
    final visited = <String>{};
    final cycles = <String>{};

    void dfs(String id) {
      if (!reachable.contains(id) || !nodes.containsKey(id)) return;
      if (visiting.contains(id)) { cycles.add(id); return; }
      if (visited.contains(id)) return;
      visiting.add(id);
      final node = nodes[id]!;
      final targets = <String>[];
      if (node.autoTargetNodeId != null) targets.add(node.autoTargetNodeId!);
      targets.addAll(node.choices.map((c) => c.targetNodeId));
      for (final target in targets) {
        if (visiting.contains(target)) {
          cycles.add(id);
          cycles.add(target);
        } else {
          dfs(target);
        }
      }
      visiting.remove(id);
      visited.add(id);
    }

    for (final id in reachable) dfs(id);
    return cycles;
  }
}
