/// Semantic events consumed by the narrative runtime.
///
/// These events must contain facts, not UI commands.
sealed class NarrativeEvent {
  const NarrativeEvent({required this.id, this.payload = const {}});
  final String id;
  final Map<String, Object?> payload;
}

final class ConvoyDetectedEvent extends NarrativeEvent {
  const ConvoyDetectedEvent({required String convoyId})
      : super(id: 'convoy.detected', payload: {'convoy_id': convoyId});
}

final class FlightEnteredRegionEvent extends NarrativeEvent {
  const FlightEnteredRegionEvent({required String regionId})
      : super(id: 'flight.entered_region', payload: {'region_id': regionId});
}

final class ScanDiscoveryCompletedEvent extends NarrativeEvent {
  const ScanDiscoveryCompletedEvent({
    required String discoveryId,
    required int scanLevel,
  }) : super(
          id: 'scan.discovery_completed',
          payload: {
            'discovery_id': discoveryId,
            'scan_level': scanLevel,
          },
        );
}

final class StationDockedEvent extends NarrativeEvent {
  const StationDockedEvent({required String stationId})
      : super(id: 'station.docked', payload: {'station_id': stationId});
}
