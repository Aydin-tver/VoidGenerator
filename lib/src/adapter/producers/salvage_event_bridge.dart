import '../wanderers_event_adapter.dart';
import '../../event.dart';

class SalvageEventBridge {
  const SalvageEventBridge(this.adapter);
  final WanderersEventAdapter adapter;

  GameEvent onSalvaged({required String sourceId, String? itemId, required int quantity, String? correlationId, String? eventId}) =>
      adapter.cargoSalvaged(sourceId: sourceId, itemId: itemId, quantity: quantity, correlationId: correlationId, eventId: eventId);
}
