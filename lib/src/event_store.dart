import 'event.dart';

abstract interface class EventStore {
  void append(GameEvent event);
  List<GameEvent> read({int? afterSequence});
  GameEvent? byId(String id);
}

class InMemoryEventStore implements EventStore {
  final List<GameEvent> _events = [];
  final Set<String> _ids = {};
  @override void append(GameEvent event) { if (_ids.add(event.id)) _events.add(event); }
  @override List<GameEvent> read({int? afterSequence}) => List.unmodifiable(afterSequence == null ? _events : _events.where((e) => (e.sequence ?? 0) > afterSequence));
  @override GameEvent? byId(String id) { for (final e in _events) { if (e.id == id) return e; } return null; }
}
