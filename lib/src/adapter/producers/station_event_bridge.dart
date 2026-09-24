import '../wanderers_event_adapter.dart';
import '../../event.dart';

class StationEventBridge {
  const StationEventBridge(this.adapter);
  final WanderersEventAdapter adapter;

  GameEvent onDocked({required String stationId, String? correlationId, String? eventId}) =>
      adapter.docked(stationId: stationId, correlationId: correlationId, eventId: eventId);
}
