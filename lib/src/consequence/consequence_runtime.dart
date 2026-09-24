import '../event.dart';
import '../event_bus.dart';
import '../condition.dart';
import 'consequence.dart';

class ConsequenceRuntime {
  ConsequenceRuntime({required this.bus, required this.rules, this.sink});

  final EventBus bus;
  final List<ConsequenceDefinition> rules;
  final ConsequenceSink? sink;
  final Set<String> _processed = {};
  final Set<String> _processedRuleEntity = {};
  bool _attached = false;

  void attach() {
    if (_attached) return;
    for (final type in rules.map((r) => conditionEventTypes(r.eventCondition)).expand((t) => t).toSet()) {
      bus.subscribe(type, _onEvent);
    }
    _attached = true;
  }

  void detach() {
    if (!_attached) return;
    for (final type in rules.map((r) => conditionEventTypes(r.eventCondition)).expand((t) => t).toSet()) {
      bus.unsubscribe(type, _onEvent);
    }
    _attached = false;
  }

  List<ConsequenceProposal> process(GameEvent event) {
    if (_processed.contains(event.id)) return const [];
    _processed.add(event.id);
    final proposals = <ConsequenceProposal>[];
    for (final rule in rules) {
      if (!rule.enabled || !rule.eventCondition.matches(event, const EvaluationContext())) continue;
      final entityKey = event.entityId ?? event.payload['entityId']?.toString() ?? event.id;
      final dedupeKey = '${rule.id}|$entityKey';
      if (rule.oncePerEntity && _processedRuleEntity.contains(dedupeKey)) continue;
      final proposal = ConsequenceProposal(
        id: '${event.id}:${rule.id}',
        ruleId: rule.id,
        event: event,
        type: rule.type,
        payload: Map.unmodifiable(rule.payload),
        priority: rule.priority,
        conflictKey: rule.conflictKey,
        conflictPolicy: rule.conflictPolicy,
      );
      proposals.add(proposal);
      if (rule.oncePerEntity) _processedRuleEntity.add(dedupeKey);
      sink?.apply(proposal);
    }
    return List.unmodifiable(proposals);
  }

  void _onEvent(GameEvent event) => process(event);

  ConsequenceRuntimeSnapshot snapshot() => ConsequenceRuntimeSnapshot(
        processedEventIds: _processed.toList(),
        processedRuleEntities: _processedRuleEntity.toList(),
      );

  void restore(ConsequenceRuntimeSnapshot snapshot) {
    _processed..clear()..addAll(snapshot.processedEventIds);
    _processedRuleEntity..clear()..addAll(snapshot.processedRuleEntities);
  }
}

class ConsequenceRuntimeSnapshot {
  const ConsequenceRuntimeSnapshot({this.processedEventIds = const [], this.processedRuleEntities = const []});
  final List<String> processedEventIds;
  final List<String> processedRuleEntities;

  Map<String, Object?> toJson() => {
        'processedEventIds': processedEventIds,
        'processedRuleEntities': processedRuleEntities,
      };

  factory ConsequenceRuntimeSnapshot.fromJson(Map<String, dynamic> json) => ConsequenceRuntimeSnapshot(
        processedEventIds: (json['processedEventIds'] as List? ?? const []).cast<String>(),
        processedRuleEntities: (json['processedRuleEntities'] as List? ?? const []).cast<String>(),
      );
}
