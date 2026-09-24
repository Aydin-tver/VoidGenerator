import '../event.dart';

typedef EventIdFactory = String Function(String type, String? entityId);
typedef EventClock = DateTime Function();

/// Framework-neutral event factories for Wanderers domain systems.
///
/// Production code should inject stable id/clock providers. This makes event
/// replay deterministic and avoids wall-clock coupling in domain producers.
class WanderersEventAdapter {
  const WanderersEventAdapter({this.idFactory = _defaultIdFactory, this.clock = _defaultClock});

  final EventIdFactory idFactory;
  final EventClock clock;

  GameEvent enteredRegion({required String regionId, String? correlationId, String? eventId}) =>
      _event('flight.entered_region', {'regionId': regionId}, source: 'flight', entityId: regionId, correlationId: correlationId, eventId: eventId);

  GameEvent docked({required String stationId, String? correlationId, String? eventId}) =>
      _event('station.docked', {'stationId': stationId}, source: 'station', entityId: stationId, correlationId: correlationId, eventId: eventId);

  GameEvent combatStarted({required String encounterId, required String enemyArchetype, String? correlationId, String? eventId}) =>
      _event('combat.started', {'encounterId': encounterId, 'enemyArchetype': enemyArchetype}, source: 'combat', entityId: encounterId, correlationId: correlationId, eventId: eventId);

  GameEvent combatVictory({required String encounterId, int riskLevel = 0, String? correlationId, String? eventId}) =>
      _event('combat.victory', {'encounterId': encounterId, 'riskLevel': riskLevel}, source: 'combat', entityId: encounterId, correlationId: correlationId, eventId: eventId);

  GameEvent combatRetreat({required String encounterId, int riskLevel = 0, String? correlationId, String? eventId}) =>
      _event('combat.retreat', {'encounterId': encounterId, 'riskLevel': riskLevel}, source: 'combat', entityId: encounterId, correlationId: correlationId, eventId: eventId);

  GameEvent cargoSalvaged({required String sourceId, String? itemId, int quantity = 0, String? correlationId, String? eventId}) =>
      _event('cargo.salvaged', {'sourceId': sourceId, 'itemId': itemId, 'quantity': quantity}, source: 'salvage', entityId: sourceId, correlationId: correlationId, eventId: eventId);

  GameEvent tradeCompleted({required String stationId, required String itemId, required int quantity, required String side, String? correlationId, String? eventId}) =>
      _event('trade.completed', {'stationId': stationId, 'itemId': itemId, 'quantity': quantity, 'side': side}, source: 'trade', entityId: stationId, correlationId: correlationId, eventId: eventId);

  GameEvent convoyDetected({required String convoyId, required String regionId, String? correlationId, String? eventId}) =>
      _event('convoy.detected', {'convoyId': convoyId, 'regionId': regionId}, source: 'convoy', entityId: convoyId, correlationId: correlationId, eventId: eventId);

  GameEvent convoyEscortTick({required String convoyId, required num integrity, String? correlationId, String? eventId}) =>
      _event('convoy.escort_tick', {'convoyId': convoyId, 'integrity': integrity}, source: 'convoy', entityId: convoyId, correlationId: correlationId, eventId: eventId);

  GameEvent convoyProtected({required String convoyId, String? correlationId, String? eventId}) =>
      _event('convoy.protected', {'convoyId': convoyId}, source: 'convoy', entityId: convoyId, correlationId: correlationId, eventId: eventId);

  GameEvent convoyDestroyed({required String convoyId, required String cause, String? correlationId, String? eventId}) =>
      _event('convoy.destroyed', {'convoyId': convoyId, 'cause': cause}, source: 'convoy', entityId: convoyId, correlationId: correlationId, eventId: eventId);

  GameEvent scanDiscoveryCompleted({required String targetId, required String discoveryId, String? correlationId, String? eventId}) =>
      _event('scan.discovery_completed', {'targetId': targetId, 'discoveryId': discoveryId}, source: 'scan', entityId: targetId, correlationId: correlationId, eventId: eventId);

  GameEvent threadResonanceDetected({required num strength, required String locationId, String? correlationId, String? eventId}) =>
      _event('thread.resonance_detected', {'strength': strength, 'locationId': locationId}, source: 'thread', entityId: locationId, correlationId: correlationId, eventId: eventId);

  GameEvent factionReputationChanged({required String factionId, required num delta, String? correlationId, String? eventId}) =>
      _event('faction.reputation_changed', {'factionId': factionId, 'delta': delta}, source: 'faction', entityId: factionId, correlationId: correlationId, eventId: eventId);

  GameEvent worldConsequenceChanged({required String key, required num delta, String? correlationId, String? eventId}) =>
      _event('world.consequence_changed', {'key': key, 'delta': delta}, source: 'world', entityId: key, correlationId: correlationId, eventId: eventId);

  GameEvent custom({required String id, required String type, required Map<String, Object?> payload, String source = '', String? entityId, String? correlationId, String? causationId, List<String> tags = const []}) => GameEvent(
    id: id, type: type, version: 1, payload: payload, tags: tags, source: source,
    entityId: entityId, correlationId: correlationId, causationId: causationId, occurredAt: clock().toUtc());

  GameEvent _event(String type, Map<String, Object?> payload, {required String source, String? entityId, String? correlationId, String? eventId}) => GameEvent(
    id: eventId ?? idFactory(type, entityId), type: type, version: 1, payload: payload,
    source: source, entityId: entityId, correlationId: correlationId, occurredAt: clock().toUtc());

  static String _defaultIdFactory(String type, String? entityId) => '$type:${DateTime.now().microsecondsSinceEpoch}:${entityId ?? ''}';
  static DateTime _defaultClock() => DateTime.now().toUtc();
}
