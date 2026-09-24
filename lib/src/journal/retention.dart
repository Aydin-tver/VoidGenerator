import 'event.dart';
import 'event_journal.dart';

abstract interface class JournalRetentionPolicy {
  bool retain(GameEventRetentionContext context);
}

class GameEventRetentionContext {
  const GameEventRetentionContext({required this.sequence, required this.latestSequence});
  final int sequence;
  final int latestSequence;
}

class KeepLastNEvents implements JournalRetentionPolicy {
  const KeepLastNEvents(this.count);
  final int count;

  @override
  bool retain(GameEventRetentionContext context) =>
      context.sequence > context.latestSequence - count;
}

/// Compaction produces a new journal image rather than mutating gameplay state.
/// Callers can atomically replace their storage file after the returned lines
/// have been written.
class JournalCompactor {
  const JournalCompactor();

  List<GameEvent> retain(EventJournal journal, JournalRetentionPolicy policy) => journal
      .read()
      .where((event) => policy.retain(GameEventRetentionContext(
            sequence: event.sequence ?? 0,
            latestSequence: journal.latestSequence,
          )))
      .toList(growable: false);
}
