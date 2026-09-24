import '../wanderers_event_adapter.dart';
import '../../event.dart';

class ScanEventBridge {
  const ScanEventBridge(this.adapter);
  final WanderersEventAdapter adapter;

  GameEvent onDiscoveryCompleted({required String targetId, required String discoveryId, String? correlationId, String? eventId}) =>
      adapter.scanDiscoveryCompleted(targetId: targetId, discoveryId: discoveryId, correlationId: correlationId, eventId: eventId);
}
