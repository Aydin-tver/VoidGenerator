import 'event.dart';

typedef EventHandler = void Function(GameEvent event);

/// Small deterministic in-process event bus. Mission objectives subscribe to
/// event types instead of polling the entire game state every frame.
class EventBus {
  final Map<String, List<EventHandler>> _handlers = {};
  int _sequence = 0;

  void subscribe(String eventType, EventHandler handler) {
    (_handlers[eventType] ??= <EventHandler>[]).add(handler);
  }

  void unsubscribe(String eventType, EventHandler handler) {
    _handlers[eventType]?.remove(handler);
  }

  GameEvent publish(GameEvent event) {
    final normalized = GameEvent(
      id: event.id,
      type: event.type,
      version: event.version,
      payload: Map.unmodifiable(event.payload),
      tags: List.unmodifiable(event.tags),
      source: event.source,
      entityId: event.entityId,
      correlationId: event.correlationId,
      causationId: event.causationId,
      sequence: event.sequence ?? ++_sequence,
      occurredAt: event.occurredAt ?? DateTime.now().toUtc(),
    );
    final handlers = List<EventHandler>.from(_handlers[normalized.type] ?? const []);
    for (final handler in handlers) {
      handler(normalized);
    }
    return normalized;
  }
}
