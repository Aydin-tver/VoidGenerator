import '../wanderers_event_adapter.dart';
import '../../event.dart';

class CombatEventBridge {
  const CombatEventBridge(this.adapter);
  final WanderersEventAdapter adapter;

  GameEvent onStarted({required String encounterId, required String enemyArchetype, String? correlationId, String? eventId}) =>
      adapter.combatStarted(encounterId: encounterId, enemyArchetype: enemyArchetype, correlationId: correlationId, eventId: eventId);
  GameEvent onVictory({required String encounterId, int riskLevel = 0, String? correlationId, String? eventId}) =>
      adapter.combatVictory(encounterId: encounterId, riskLevel: riskLevel, correlationId: correlationId, eventId: eventId);
  GameEvent onRetreat({required String encounterId, int riskLevel = 0, String? correlationId, String? eventId}) =>
      adapter.combatRetreat(encounterId: encounterId, riskLevel: riskLevel, correlationId: correlationId, eventId: eventId);
}
