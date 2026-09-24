import 'package:test/test.dart';
import 'package:void_event_engine/void_event_engine.dart';

GameEvent event(String id, String type, {int? sequence}) => GameEvent(
  id: id,
  type: type,
  version: 1,
  sequence: sequence,
  payload: const {},
);

void main() {
  test('journal assigns contiguous sequences and is idempotent by event id', () {
    final journal = InMemoryEventJournal();
    final first = journal.append(event('e1', 'test.one'));
    final duplicate = journal.append(event('e1', 'test.one'));
    final second = journal.append(event('e2', 'test.two'));

    expect(first.sequence, 1);
    expect(duplicate.sequence, 1);
    expect(second.sequence, 2);
    expect(journal.length, 2);
  });

  test('journal reads after snapshot boundary', () {
    final journal = InMemoryEventJournal();
    journal.append(event('e1', 'a'));
    journal.append(event('e2', 'b'));
    journal.append(event('e3', 'c'));

    expect(journal.read(afterSequence: 1).map((e) => e.id), ['e2', 'e3']);
  });

  test('codec round-trips event metadata', () {
    const codec = EventJsonCodec();
    final original = GameEvent(
      id: 'e1', type: 'combat.victory', version: 2,
      payload: const {'enemyId': 'pirate_01'}, tags: const ['combat'],
      source: 'combat', entityId: 'ship_01', correlationId: 'mission_1',
      causationId: 'cmd_1', sequence: 7,
      occurredAt: DateTime.utc(2026, 9, 24, 1, 2, 3),
    );
    final restored = codec.decodeLine(codec.encodeLine(original));
    expect(restored.id, original.id);
    expect(restored.type, original.type);
    expect(restored.version, original.version);
    expect(restored.sequence, original.sequence);
    expect(restored.correlationId, original.correlationId);
    expect(restored.payload, original.payload);
  });
}
