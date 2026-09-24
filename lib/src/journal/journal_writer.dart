import '../event.dart';
import 'event_journal.dart';

/// Transaction boundary for event production. A producer appends the fact and
/// receives the canonical sequence-assigned event that should then be published.
class JournalEventWriter {
  const JournalEventWriter(this.journal);
  final EventJournal journal;

  GameEvent record(GameEvent event) => journal.append(event);
}
