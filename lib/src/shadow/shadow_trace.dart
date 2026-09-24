import 'dart:convert';
import '../event.dart';
import 'shadow_run.dart';

/// Stable, serializable shadow trace used for CI diffing and deterministic replay.
class ShadowTrace {
  const ShadowTrace({required this.missionId, required this.steps});
  final String missionId;
  final List<ShadowTraceStep> steps;

  Map<String, Object?> toJson() => {
        'missionId': missionId,
        'steps': steps.map((e) => e.toJson()).toList(),
      };

  String encode() => jsonEncode(toJson());
}

class ShadowTraceStep {
  const ShadowTraceStep({required this.event, required this.snapshot, this.matches, this.mismatches = const []});
  final GameEvent event;
  final ShadowMissionSnapshot snapshot;
  final bool? matches;
  final List<String> mismatches;

  Map<String, Object?> toJson() => {
        'event': {
          'id': event.id,
          'type': event.type,
          'version': event.version,
          'payload': _stable(event.payload),
          'source': event.source,
          'entityId': event.entityId,
          'correlationId': event.correlationId,
          'causationId': event.causationId,
          'sequence': event.sequence,
        },
        'snapshot': {
          'active': snapshot.active,
          'completed': snapshot.completed,
          'failed': snapshot.failed,
          'activeStepIds': [...snapshot.activeStepIds]..sort(),
          'progress': _stable(snapshot.progress),
          'currentOutcomeId': snapshot.currentOutcomeId,
          'effects': snapshot.effects.map((e) => {
                'outcomeId': e.outcomeId,
                'type': e.type,
                'payload': _stable(e.payload),
              }).toList(),
        },
        'matches': matches,
        'mismatches': mismatches,
      };
}

Object? _stable(Object? value) {
  if (value is Map) {
    final keys = value.keys.map((e) => e.toString()).toList()..sort();
    return {for (final key in keys) key: _stable(value[key])};
  }
  if (value is Iterable) return value.map(_stable).toList();
  return value;
}
