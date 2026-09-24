import '../event.dart';
import '../event_bus.dart';
import 'wanderers_event_adapter.dart';

/// Application boundary intended to be injected into Wanderers systems.
/// Systems call semantic methods; mission code never needs to know the bus API.
class WanderersEventGateway {
  WanderersEventGateway(this.bus, {WanderersEventAdapter? adapter})
      : adapter = adapter ?? const WanderersEventAdapter();

  final EventBus bus;
  final WanderersEventAdapter adapter;

  GameEvent publish(GameEvent event) => bus.publish(event);

  GameEvent publishCustom({required String id, required String type,
      required Map<String, Object?> payload, String source = '', String? entityId,
      String? correlationId, String? causationId}) => publish(adapter.custom(
        id: id, type: type, payload: payload, source: source,
        entityId: entityId, correlationId: correlationId, causationId: causationId));
}
