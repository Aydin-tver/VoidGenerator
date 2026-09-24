import '../event.dart';
import 'event_codec.dart';

abstract interface class EventJournal {
  GameEvent append(GameEvent event);
  List<GameEvent> read({int? afterSequence, int? beforeOrAtSequence});
  List<GameEvent> readCorrelation(String correlationId);
  GameEvent? byId(String id);
  int get latestSequence;
  int get length;
}

/// In-memory journal with the same sequence semantics as persistent journals.
class InMemoryEventJournal implements EventJournal {
  final List<GameEvent> _events = [];
  final Set<String> _ids = {};
  int _nextSequence = 1;

  @override
  GameEvent append(GameEvent event) {
    if (_ids.contains(event.id)) return byId(event.id)!;
    final persisted = event.sequence == null ? _withSequence(event, _nextSequence) : event;
    if (persisted.sequence != _nextSequence) {
      throw StateError('Expected sequence $_nextSequence, got ${persisted.sequence}');
    }
    _events.add(persisted);
    _ids.add(persisted.id);
    _nextSequence++;
    return persisted;
  }

  @override
  List<GameEvent> read({int? afterSequence, int? beforeOrAtSequence}) => List.unmodifiable(
        _events.where((event) {
          final sequence = event.sequence ?? 0;
          return (afterSequence == null || sequence > afterSequence) &&
              (beforeOrAtSequence == null || sequence <= beforeOrAtSequence);
        }),
      );

  @override
  List<GameEvent> readCorrelation(String correlationId) =>
      List.unmodifiable(_events.where((event) => event.correlationId == correlationId));

  @override
  GameEvent? byId(String id) => _events.where((event) => event.id == id).firstOrNull;

  @override
  int get latestSequence => _nextSequence - 1;

  @override
  int get length => _events.length;

  static GameEvent _withSequence(GameEvent event, int sequence) => GameEvent(
        id: event.id,
        type: event.type,
        version: event.version,
        payload: event.payload,
        tags: event.tags,
        source: event.source,
        entityId: event.entityId,
        correlationId: event.correlationId,
        causationId: event.causationId,
        sequence: sequence,
        occurredAt: event.occurredAt,
      );
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

/// A JSON-lines journal is intentionally append-only. It can be backed by a
/// local file in tooling/tests and later replaced by a database adapter in the
/// game without changing mission/runtime code.
class JsonLinesEventJournal implements EventJournal {
  JsonLinesEventJournal(this._lines, {EventJsonCodec codec = const EventJsonCodec()}) : _codec = codec {
    _load();
  }

  final List<String> _lines;
  final EventJsonCodec _codec;
  final List<GameEvent> _events = [];
  final Set<String> _ids = {};
  int _nextSequence = 1;

  void _load() {
    _events.clear();
    _ids.clear();
    _nextSequence = 1;
    for (final line in _lines.where((line) => line.trim().isNotEmpty)) {
      final event = _codec.decodeLine(line);
      if (event.sequence == null || event.sequence != _nextSequence) {
        throw StateError('Journal sequence is not contiguous at ${event.id}');
      }
      if (!_ids.add(event.id)) throw StateError('Duplicate journal event id: ${event.id}');
      _events.add(event);
      _nextSequence++;
    }
  }

  @override
  GameEvent append(GameEvent event) {
    final existing = byId(event.id);
    if (existing != null) return existing;
    final persisted = _copyWithSequence(event, _nextSequence);
    _lines.add(_codec.encodeLine(persisted));
    _events.add(persisted);
    _ids.add(persisted.id);
    _nextSequence++;
    return persisted;
  }

  @override
  List<GameEvent> read({int? afterSequence, int? beforeOrAtSequence}) => List.unmodifiable(
        _events.where((event) {
          final sequence = event.sequence ?? 0;
          return (afterSequence == null || sequence > afterSequence) &&
              (beforeOrAtSequence == null || sequence <= beforeOrAtSequence);
        }),
      );

  @override
  List<GameEvent> readCorrelation(String correlationId) =>
      List.unmodifiable(_events.where((event) => event.correlationId == correlationId));

  @override
  GameEvent? byId(String id) => _events.where((event) => event.id == id).firstOrNull;

  @override
  int get latestSequence => _nextSequence - 1;

  @override
  int get length => _events.length;

  static GameEvent _copyWithSequence(GameEvent event, int sequence) => GameEvent(
        id: event.id,
        type: event.type,
        version: event.version,
        payload: event.payload,
        tags: event.tags,
        source: event.source,
        entityId: event.entityId,
        correlationId: event.correlationId,
        causationId: event.causationId,
        sequence: sequence,
        occurredAt: event.occurredAt,
      );
}
