import 'package:test/test.dart';

import '../../lib/narrative/events/narrative_event.dart';
import '../../lib/narrative/runtime/rpg_vertical_slice_runtime.dart';
import '../../lib/narrative/state/narrative_state.dart';
import '../../lib/narrative/adapters/narrative_host_adapter.dart';

class FakeHost implements NarrativeHostAdapter {
  final unlocked = <String>[];
  final refreshed = <String>[];
  final stationRequests = <String>[];

  @override
  bool hasCapability(String capability, int minimumLevel) => false;

  @override
  void requestDialogueRefresh(String characterId) {
    refreshed.add(characterId);
  }

  @override
  void requestNarrativeMissionUnlock(String missionId) {
    unlocked.add(missionId);
  }

  @override
  void requestStationNarrativeState(String stationId, String state) {
    stationRequests.add('$stationId:$state');
  }
}

void main() {
  test('convoy event creates route knowledge', () {
    final state = NarrativeState();
    final host = FakeHost();
    final runtime = RpgVerticalSliceRuntime(state: state, host: host);

    runtime.consume(const ConvoyDetectedEvent(convoyId: 'convoy_01'));

    expect(
      state.hasKnowledge('knowledge.route_irregularity_observed'),
      isTrue,
    );
  });

  test('report consequence is idempotent', () {
    final state = NarrativeState();
    final host = FakeHost();
    final runtime = RpgVerticalSliceRuntime(state: state, host: host);

    runtime.reportRouteAmendment();
    runtime.reportRouteAmendment();

    expect(state.factions['tidari']!.trust, 10);
    expect(state.factions['omnicorp']!.trust, -5);
  });

  test('withhold creates different trajectory', () {
    final state = NarrativeState();
    final host = FakeHost();
    final runtime = RpgVerticalSliceRuntime(state: state, host: host);

    runtime.withholdRouteAmendment();

    expect(state.factions['free_merchants']!.trust, 5);
    expect(
      state.npcs['lena_voss']!.memories,
      contains('route_amendment_withheld'),
    );
  });

  test('scan level two creates corroborated knowledge', () {
    final state = NarrativeState();
    final host = FakeHost();
    final runtime = RpgVerticalSliceRuntime(state: state, host: host);

    runtime.consume(
      const ScanDiscoveryCompletedEvent(
        discoveryId: 'ferrum_pattern',
        scanLevel: 2,
      ),
    );

    expect(
      state.knowledge['knowledge.ferrum_pattern_observed']!.state,
      'CORROBORATED',
    );
  });
}
