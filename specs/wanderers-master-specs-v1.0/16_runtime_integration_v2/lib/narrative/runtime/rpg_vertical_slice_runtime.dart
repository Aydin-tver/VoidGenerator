import '../events/narrative_event.dart';
import '../state/narrative_state.dart';
import '../adapters/narrative_host_adapter.dart';

class RpgVerticalSliceRuntime {
  RpgVerticalSliceRuntime({
    required this.state,
    required this.host,
  });

  final NarrativeState state;
  final NarrativeHostAdapter host;

  void consume(NarrativeEvent event) {
    switch (event.id) {
      case 'convoy.detected':
        _grant(
          id: 'knowledge.route_irregularity_observed',
          state: 'OBSERVED',
          source: event.id,
        );
      case 'scan.discovery_completed':
        _handleScan(event);
      case 'station.docked':
        _handleDock(event);
      case 'flight.entered_region':
        break;
    }
  }

  void reportRouteAmendment() {
    _applyOnce(
      'consequence.reported_route_amendment',
      () {
        _trust('tidari', 10);
        _trust('omnicorp', -5);
        _remember('dispatcher_tidari', 'route_amendment_reported');
        _remember('lena_voss', 'route_amendment_reported');
        state.stationStates['solaris'] = 'under_investigation';
        host.requestNarrativeMissionUnlock('msr15_03_ferrum_anomaly');
        host.requestDialogueRefresh('dispatcher_tidari');
      },
    );
  }

  void withholdRouteAmendment() {
    _applyOnce(
      'consequence.withheld_route_amendment',
      () {
        _trust('free_merchants', 5);
        _remember('lena_voss', 'route_amendment_withheld');
        state.stationStates['solaris'] = 'merchant_discussion';
        host.requestNarrativeMissionUnlock('msr15_03_ferrum_anomaly');
        host.requestDialogueRefresh('lena_voss');
      },
    );
  }

  void _handleScan(NarrativeEvent event) {
    final level = event.payload['scan_level'];
    if (level is int && level >= 2) {
      _grant(
        id: 'knowledge.ferrum_pattern_observed',
        state: 'CORROBORATED',
        source: event.id,
      );
      _applyOnce(
        'consequence.ferrum_scan',
        () => host.requestNarrativeMissionUnlock('msr15_05_next_lead'),
      );
    }
  }

  void _handleDock(NarrativeEvent event) {
    final stationId = event.payload['station_id'];
    if (stationId == 'solaris' &&
        state.hasKnowledge('knowledge.ferrum_pattern_observed')) {
      host.requestDialogueRefresh('lena_voss');
      host.requestDialogueRefresh('dispatcher_tidari');
    }
  }

  void _grant({
    required String id,
    required String state: knowledgeState,
    required String source,
  }) {
    final existing = this.state.knowledge[id];
    if (existing == null) {
      this.state.knowledge[id] = KnowledgeEntry(
        id: id,
        state: knowledgeState,
        sources: [source],
      );
    } else if (!existing.sources.contains(source)) {
      existing.sources.add(source);
    }
  }

  void _trust(String factionId, int delta) {
    final faction = state.factions.putIfAbsent(
      factionId,
      () => FactionStoryState(),
    );
    faction.trust += delta;
  }

  void _remember(String npcId, String memory) {
    final npc = state.npcs.putIfAbsent(
      npcId,
      () => NpcMemoryState(),
    );
    npc.memories.add(memory);
  }

  void _applyOnce(String key, void Function() effect) {
    if (state.effectApplied(key)) return;
    effect();
    state.markEffectApplied(key);
  }
}
