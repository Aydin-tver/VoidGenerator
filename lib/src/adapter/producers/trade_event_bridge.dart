import '../wanderers_event_adapter.dart';
import '../../event.dart';

class TradeEventBridge {
  const TradeEventBridge(this.adapter);
  final WanderersEventAdapter adapter;

  GameEvent onCompleted({required String stationId, required String itemId, required int quantity, required String side, String? correlationId, String? eventId}) =>
      adapter.tradeCompleted(stationId: stationId, itemId: itemId, quantity: quantity, side: side, correlationId: correlationId, eventId: eventId);
}
