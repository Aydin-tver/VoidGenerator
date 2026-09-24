import '../event.dart';
import 'wanderers_event_adapter.dart';

/// Thin producer facade for a Wanderers domain subsystem.
/// Domain code calls a semantic method; the facade publishes only facts.
class WanderersEventProducer {
  const WanderersEventProducer(this.adapter, this.publish);
  final WanderersEventAdapter adapter;
  final GameEvent Function(GameEvent) publish;

  GameEvent flightEnteredRegion(String regionId, {String? correlationId, String? eventId}) => publish(adapter.enteredRegion(regionId: regionId, correlationId: correlationId, eventId: eventId));
  GameEvent combatVictory(String encounterId, {int riskLevel = 0, String? correlationId, String? eventId}) => publish(adapter.combatVictory(encounterId: encounterId, riskLevel: riskLevel, correlationId: correlationId, eventId: eventId));
  GameEvent cargoSalvaged(String sourceId, {String? itemId, required int quantity, String? correlationId, String? eventId}) => publish(adapter.cargoSalvaged(sourceId: sourceId, itemId: itemId, quantity: quantity, correlationId: correlationId, eventId: eventId));
  GameEvent convoyDetected(String convoyId, String regionId, {String? correlationId, String? eventId}) => publish(adapter.convoyDetected(convoyId: convoyId, regionId: regionId, correlationId: correlationId, eventId: eventId));
  GameEvent convoyEscortTick(String convoyId, num integrity, {String? correlationId, String? eventId}) => publish(adapter.convoyEscortTick(convoyId: convoyId, integrity: integrity, correlationId: correlationId, eventId: eventId));
  GameEvent convoyProtected(String convoyId, {String? correlationId, String? eventId}) => publish(adapter.convoyProtected(convoyId: convoyId, correlationId: correlationId, eventId: eventId));
}
