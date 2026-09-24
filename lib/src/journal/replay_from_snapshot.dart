import '../event.dart';
import '../event_bus.dart';
import '../mission_runtime.dart';
import 'event_journal.dart';

class JournalReplayResult {
  const JournalReplayResult({required this.replayedEvents, required this.lastSequence});
  final int replayedEvents;
  final int? lastSequence;
}

/// Restores a mission snapshot and replays only events after the snapshot
/// sequence. The journal remains the source of facts; the runtime reconstructs
/// derived mission state from those facts.
class MissionJournalReplayer {
  const MissionJournalReplayer();

  JournalReplayResult replay({
    required MissionRuntime runtime,
    required MissionSnapshot snapshot,
    required EventJournal journal,
  }) {
    runtime.restore(snapshot);
    final bus = runtime.bus;
    runtime.attach();
    var count = 0;
    for (final event in journal.read(afterSequence: snapshot.lastSequence)) {
      if (runtime.completed || runtime.failed) break;
      runtime.tick(event.occurredAt ?? snapshot.startedAt ?? DateTime.utc(2000));
      bus.publish(event);
      count++;
    }
    runtime.detach();
    return JournalReplayResult(replayedEvents: count, lastSequence: runtime.lastSequence);
  }
}
