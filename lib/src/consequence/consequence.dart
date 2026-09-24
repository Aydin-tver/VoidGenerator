import '../condition.dart';
import '../event.dart';

/// Declarative rule that turns a domain event into a consequence proposal.
/// The rule never mutates world state directly.
class ConsequenceDefinition {
  const ConsequenceDefinition({
    required this.id,
    required this.eventCondition,
    required this.type,
    this.payload = const {},
    this.oncePerEntity = false,
    this.enabled = true,
    this.priority = 0,
    this.conflictKey,
    this.conflictPolicy = ConsequenceConflictPolicy.additive,
  });

  final String id;
  final Condition eventCondition;
  final String type;
  final Map<String, Object?> payload;
  final bool oncePerEntity;
  final bool enabled;
  final int priority;
  /// Proposals with the same key participate in one deterministic conflict group.
  /// If omitted, the resolver derives a key from type and common identity fields.
  final String? conflictKey;
  final ConsequenceConflictPolicy conflictPolicy;
}

enum ConsequenceConflictPolicy {
  /// All proposals are accepted. The authoritative host decides how to combine them.
  additive,
  /// Exactly one proposal in the group is accepted: highest priority, then stable id.
  exclusive,
  /// The first stable proposal wins; later proposals are rejected as duplicates.
  rejectDuplicate,
}

/// A proposed state change produced from an observed fact.
class ConsequenceProposal {
  const ConsequenceProposal({
    required this.id,
    required this.ruleId,
    required this.event,
    required this.type,
    this.payload = const {},
    this.priority = 0,
    this.conflictKey,
    this.conflictPolicy = ConsequenceConflictPolicy.additive,
  });

  final String id;
  final String ruleId;
  final GameEvent event;
  final String type;
  final Map<String, Object?> payload;
  final int priority;
  final String? conflictKey;
  final ConsequenceConflictPolicy conflictPolicy;

  Map<String, Object?> toJson() => {
        'id': id,
        'ruleId': ruleId,
        'eventId': event.id,
        'eventType': event.type,
        'type': type,
        'payload': payload,
        'priority': priority,
        if (conflictKey != null) 'conflictKey': conflictKey,
        'conflictPolicy': conflictPolicy.name,
      };
}

/// The authoritative game owns this interface. The event engine only proposes.
abstract interface class ConsequenceSink {
  void apply(ConsequenceProposal proposal);
}
