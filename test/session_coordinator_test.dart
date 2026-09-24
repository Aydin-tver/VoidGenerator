import 'package:test/test.dart';
import 'package:void_event_engine/void_event_engine.dart';

void main() {
  test('captures components at the latest journal sequence', () {
    final journal = InMemoryEventJournal();
    journal.append(const GameEvent(id: 'e1', type: 'test.happened', version: 1, payload: {}));
    final coordinator = RuntimePersistenceCoordinator(sessionId: 's1', journal: journal, bus: EventBus());
    var value = 7;
    coordinator.register(CallbackSnapshotComponent(
      id: 'demo',
      capture: () => {'value': value},
      restore: (state) => value = (state['value'] as num).toInt(),
    ));
    final snapshot = coordinator.capture();
    expect(snapshot.lastEventSequence, 1);
    expect(snapshot.components['demo']!['state'], {'value': 7});
  });

  test('restore and replay only publishes events after the checkpoint', () {
    final journal = InMemoryEventJournal();
    journal.append(const GameEvent(id: 'e1', type: 'test.happened', version: 1, payload: {}));
    journal.append(const GameEvent(id: 'e2', type: 'test.happened', version: 1, payload: {}));
    final bus = EventBus();
    final received = <String>[];
    bus.subscribe('test.happened', (event) => received.add(event.id));
    final coordinator = RuntimePersistenceCoordinator(sessionId: 's1', journal: journal, bus: bus);
    coordinator.register(CallbackSnapshotComponent(id: 'demo', capture: () => {'value': 1}, restore: (_) {}));
    final snapshot = coordinator.capture();
    // A later event exists after the checkpoint.
    journal.append(const GameEvent(id: 'e3', type: 'test.happened', version: 1, payload: {}));
    final result = coordinator.restoreAndReplay(snapshot);
    expect(received, ['e3']);
    expect(result.replayedEvents, 1);
    expect(result.lastSequence, 3);
  });

  test('rejects a newer component schema', () {
    final journal = InMemoryEventJournal();
    final coordinator = RuntimePersistenceCoordinator(sessionId: 's1', journal: journal, bus: EventBus());
    coordinator.register(CallbackSnapshotComponent(id: 'demo', schemaVersion: 1, capture: () => {}, restore: (_) {}));
    final snapshot = EngineSessionSnapshot(
      sessionId: 's1', schemaVersion: 1, lastEventSequence: null,
      components: {'demo': {'_schemaVersion': 2, 'state': {}}},
    );
    expect(() => coordinator.restore(snapshot), throwsStateError);
  });
}
