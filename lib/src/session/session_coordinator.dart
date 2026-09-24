import '../event.dart';
import '../event_bus.dart';
import '../journal/event_journal.dart';
import 'session_snapshot.dart';

class SessionReplayResult {
  const SessionReplayResult({required this.replayedEvents, required this.lastSequence, required this.sessionId});
  final int replayedEvents;
  final int? lastSequence;
  final String sessionId;
}

/// Coordinates one deterministic save boundary across mission, narrative,
/// consequence and future host-owned components.
class RuntimePersistenceCoordinator {
  RuntimePersistenceCoordinator({
    required this.sessionId,
    required this.journal,
    required this.bus,
    this.schemaVersion = 1,
    this.correlationId,
  });

  final String sessionId;
  final EventJournal journal;
  final EventBus bus;
  final int schemaVersion;
  final String? correlationId;
  final Map<String, SessionSnapshotComponent> _components = {};

  void register(SessionSnapshotComponent component) {
    if (_components.containsKey(component.id)) {
      throw StateError('Duplicate session component: ${component.id}');
    }
    _components[component.id] = component;
  }

  EngineSessionSnapshot capture({DateTime? savedAt}) {
    final components = <String, Map<String, Object?>>{};
    for (final component in _components.values) {
      components[component.id] = {
        '_schemaVersion': component.schemaVersion,
        'state': component.capture(),
      };
    }
    return EngineSessionSnapshot(
      sessionId: sessionId,
      schemaVersion: schemaVersion,
      lastEventSequence: journal.latestSequence == 0 ? null : journal.latestSequence,
      components: components,
      savedAt: savedAt,
      correlationId: correlationId,
    );
  }

  void restore(EngineSessionSnapshot snapshot) {
    if (snapshot.sessionId != sessionId) throw ArgumentError('Session mismatch: ${snapshot.sessionId}');
    if (snapshot.schemaVersion > schemaVersion) {
      throw StateError('Snapshot schema ${snapshot.schemaVersion} is newer than runtime $schemaVersion');
    }
    for (final entry in snapshot.components.entries) {
      final component = _components[entry.key];
      if (component == null) continue;
      final schema = (entry.value['_schemaVersion'] as num?)?.toInt() ?? 1;
      if (schema > component.schemaVersion) {
        throw StateError('Component ${entry.key} schema $schema is newer than runtime ${component.schemaVersion}');
      }
      final state = entry.value['state'];
      if (state is! Map) throw StateError('Invalid state for component ${entry.key}');
      component.restore(Map<String, Object?>.from(state));
    }
  }

  SessionReplayResult restoreAndReplay(EngineSessionSnapshot snapshot, {bool stopOnRuntimeError = true}) {
    restore(snapshot);
    var count = 0;
    int? last;
    for (final event in journal.read(afterSequence: snapshot.lastEventSequence)) {
      try {
        bus.publish(event);
      } catch (_) {
        if (stopOnRuntimeError) rethrow;
      }
      count++;
      last = event.sequence;
    }
    return SessionReplayResult(replayedEvents: count, lastSequence: last ?? snapshot.lastEventSequence, sessionId: sessionId);
  }
}
