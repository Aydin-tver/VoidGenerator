import '../condition.dart';
import '../event.dart';

class NarrativeState {
  const NarrativeState({this.flags = const {}, this.values = const {}, this.strings = const {}, this.facts = const {}});
  final Map<String, bool> flags;
  final Map<String, num> values;
  final Map<String, String> strings;
  final Map<String, bool> facts;

  bool flag(String id) => flags[id] ?? false;
  num value(String id) => values[id] ?? 0;
  String? string(String id) => strings[id];
  bool fact(String id) => facts[id] ?? false;
}

abstract interface class NarrativeCondition {
  bool matches(NarrativeState state);
}

class AlwaysNarrativeCondition implements NarrativeCondition {
  const AlwaysNarrativeCondition();
  @override bool matches(NarrativeState state) => true;
}

class FlagNarrativeCondition implements NarrativeCondition {
  const FlagNarrativeCondition(this.id, {this.expected = true});
  final String id;
  final bool expected;
  @override bool matches(NarrativeState state) => state.flag(id) == expected;
}

class ValueNarrativeCondition implements NarrativeCondition {
  const ValueNarrativeCondition(this.id, {this.equals, this.greaterThan, this.lessThan});
  final String id;
  final num? equals;
  final num? greaterThan;
  final num? lessThan;
  @override bool matches(NarrativeState state) {
    final value = state.value(id);
    if (equals != null && value != equals) return false;
    if (greaterThan != null && value <= greaterThan!) return false;
    if (lessThan != null && value >= lessThan!) return false;
    return true;
  }
}

class FactNarrativeCondition implements NarrativeCondition {
  const FactNarrativeCondition(this.id, {this.expected = true});
  final String id;
  final bool expected;
  @override bool matches(NarrativeState state) => state.fact(id) == expected;
}

class AllNarrativeCondition implements NarrativeCondition {
  const AllNarrativeCondition(this.children);
  final List<NarrativeCondition> children;
  @override bool matches(NarrativeState state) => children.every((c) => c.matches(state));
}
class AnyNarrativeCondition implements NarrativeCondition {
  const AnyNarrativeCondition(this.children);
  final List<NarrativeCondition> children;
  @override bool matches(NarrativeState state) => children.any((c) => c.matches(state));
}
class NotNarrativeCondition implements NarrativeCondition {
  const NotNarrativeCondition(this.child);
  final NarrativeCondition child;
  @override bool matches(NarrativeState state) => !child.matches(state);
}

class NarrativeChoice {
  const NarrativeChoice({required this.id, required this.targetNodeId, this.condition = const AlwaysNarrativeCondition(), this.consequenceTypes = const [], this.tags = const []});
  final String id;
  final String targetNodeId;
  final NarrativeCondition condition;
  final List<String> consequenceTypes;
  final List<String> tags;
}

class NarrativeNode {
  const NarrativeNode({required this.id, this.textKey = '', this.enterEventType, this.autoTargetNodeId, this.terminal = false, this.choices = const [], this.enterConsequences = const [], this.tags = const []});
  final String id;
  final String textKey;
  final String? enterEventType;
  final String? autoTargetNodeId;
  final bool terminal;
  final List<NarrativeChoice> choices;
  final List<String> enterConsequences;
  final List<String> tags;

  List<NarrativeChoice> availableChoices(NarrativeState state) => choices.where((c) => c.condition.matches(state)).toList(growable: false);
}

class NarrativeDefinition {
  const NarrativeDefinition({required this.id, required this.version, required this.startNodeId, required this.nodes, this.tags = const []});
  final String id;
  final int version;
  final String startNodeId;
  final List<NarrativeNode> nodes;
  final List<String> tags;

  NarrativeNode? node(String id) => nodes.cast<NarrativeNode?>().firstWhere((n) => n!.id == id, orElse: () => null);
}

class NarrativeSnapshot {
  const NarrativeSnapshot({required this.storyId, required this.definitionVersion, required this.active, required this.completed, required this.currentNodeId, required this.visitedNodeIds, required this.consumedEventIds, this.lastSequence, this.startedAt});
  final String storyId;
  final int definitionVersion;
  final bool active;
  final bool completed;
  final String currentNodeId;
  final List<String> visitedNodeIds;
  final List<String> consumedEventIds;
  final int? lastSequence;
  final DateTime? startedAt;

  Map<String,Object?> toJson() => {
    'storyId': storyId, 'definitionVersion': definitionVersion, 'active': active, 'completed': completed,
    'currentNodeId': currentNodeId, 'visitedNodeIds': visitedNodeIds, 'consumedEventIds': consumedEventIds,
    'lastSequence': lastSequence, 'startedAt': startedAt?.toIso8601String(),
  };
  factory NarrativeSnapshot.fromJson(Map<String,dynamic> j) => NarrativeSnapshot(
    storyId: j['storyId'] as String, definitionVersion: (j['definitionVersion'] as num).toInt(),
    active: j['active'] as bool, completed: j['completed'] as bool, currentNodeId: j['currentNodeId'] as String,
    visitedNodeIds: (j['visitedNodeIds'] as List? ?? const []).cast<String>(), consumedEventIds: (j['consumedEventIds'] as List? ?? const []).cast<String>(),
    lastSequence: (j['lastSequence'] as num?)?.toInt(), startedAt: j['startedAt'] == null ? null : DateTime.parse(j['startedAt'] as String),
  );
}

typedef NarrativeConsequenceHandler = void Function(String storyId, String nodeId, String consequenceType, String? choiceId);
typedef NarrativeTransitionHandler = void Function(String storyId, String fromNodeId, String toNodeId, String? choiceId);

class NarrativeRuntime {
  NarrativeRuntime(this.definition, {this.consequenceHandler, this.transitionHandler});
  final NarrativeDefinition definition;
  final NarrativeConsequenceHandler? consequenceHandler;
  final NarrativeTransitionHandler? transitionHandler;
  bool active = false;
  bool completed = false;
  String? currentNodeId;
  DateTime? startedAt;
  int? lastSequence;
  final Set<String> visitedNodeIds = {};
  final Set<String> consumedEventIds = {};

  NarrativeNode get currentNode {
    final id = currentNodeId;
    if (id == null) throw StateError('Narrative is not started');
    final node = definition.node(id);
    if (node == null) throw StateError('Unknown narrative node: $id');
    return node;
  }

  void start({DateTime? now, NarrativeState state = const NarrativeState()}) {
    if (definition.node(definition.startNodeId) == null) throw StateError('Unknown start node: ${definition.startNodeId}');
    active = true; completed = false; startedAt = now ?? DateTime.utc(2000); lastSequence = null;
    visitedNodeIds.clear(); consumedEventIds.clear();
    _enter(definition.startNodeId, null, state);
  }

  void onEvent(GameEvent event, NarrativeState state) {
    if (!active || completed || consumedEventIds.contains(event.id)) return;
    final node = currentNode;
    if (node.enterEventType != null && node.enterEventType != event.type) return;
    if (node.enterEventType == null) return;
    consumedEventIds.add(event.id); lastSequence = event.sequence ?? lastSequence;
    if (node.autoTargetNodeId != null) _transition(node.autoTargetNodeId!, null, state);
    else if (node.terminal) _complete();
  }

  List<NarrativeChoice> availableChoices(NarrativeState state) => currentNode.availableChoices(state);

  void choose(String choiceId, NarrativeState state) {
    if (!active || completed) throw StateError('Narrative is not active');
    final node = currentNode;
    final choice = node.choices.where((c) => c.id == choiceId).firstOrNull;
    if (choice == null) throw ArgumentError('Unknown choice $choiceId at node ${node.id}');
    if (!choice.condition.matches(state)) throw StateError('Choice condition is not satisfied: $choiceId');
    _transition(choice.targetNodeId, choiceId, state, extraConsequences: choice.consequenceTypes);
  }

  void _enter(String nodeId, String? choiceId, NarrativeState state, {List<String> extraConsequences = const []}) {
    final node = definition.node(nodeId);
    if (node == null) throw StateError('Unknown narrative node: $nodeId');
    currentNodeId = nodeId; visitedNodeIds.add(nodeId);
    for (final type in [...node.enterConsequences, ...extraConsequences]) consequenceHandler?.call(definition.id, nodeId, type, choiceId);
    if (node.terminal) _complete();
  }

  void _transition(String nodeId, String? choiceId, NarrativeState state, {List<String> extraConsequences = const []}) {
    final from = currentNodeId!;
    _enter(nodeId, choiceId, state, extraConsequences: extraConsequences);
    transitionHandler?.call(definition.id, from, nodeId, choiceId);
  }

  void _complete() { completed = true; active = false; }

  NarrativeSnapshot snapshot() => NarrativeSnapshot(storyId: definition.id, definitionVersion: definition.version, active: active, completed: completed, currentNodeId: currentNodeId ?? definition.startNodeId, visitedNodeIds: visitedNodeIds.toList(), consumedEventIds: consumedEventIds.toList(), lastSequence: lastSequence, startedAt: startedAt);

  void restore(NarrativeSnapshot snapshot) {
    if (snapshot.storyId != definition.id) throw ArgumentError('Snapshot story mismatch');
    active = snapshot.active; completed = snapshot.completed; currentNodeId = snapshot.currentNodeId; startedAt = snapshot.startedAt; lastSequence = snapshot.lastSequence;
    visitedNodeIds..clear()..addAll(snapshot.visitedNodeIds); consumedEventIds..clear()..addAll(snapshot.consumedEventIds);
  }
}

extension<T> on Iterable<T> { T? get firstOrNull => isEmpty ? null : first; }
