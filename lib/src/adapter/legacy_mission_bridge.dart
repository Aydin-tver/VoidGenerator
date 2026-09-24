import '../event.dart';
import 'wanderers_event_adapter.dart';

/// Temporary compatibility bridge for the pre-event mission API.
///
/// It translates the old record(type/target/amount) vocabulary into semantic
/// events. It does not complete or reward missions itself. This makes it safe
/// to run beside the legacy GameplayMissionUseCase during shadow migration.
class LegacyMissionEventBridge {
  LegacyMissionEventBridge({WanderersEventAdapter? adapter})
      : adapter = adapter ?? const WanderersEventAdapter();

  final WanderersEventAdapter adapter;

  GameEvent? translate(String type,
      {String target = '', int amount = 1, Map<String, Object?> context = const {}}) {
    switch (type) {
      case 'combat_win':
        return adapter.combatVictory(
          encounterId: target.isEmpty ? 'legacy' : target,
          riskLevel: (context['riskLevel'] as num?)?.toInt() ?? 0,
        );
      case 'cargo_salvage':
        return adapter.cargoSalvaged(
          sourceId: target.isEmpty ? 'legacy' : target,
          itemId: context['itemId'] as String?,
          quantity: amount,
        );
      case 'dock':
        return adapter.docked(stationId: target.isEmpty ? 'legacy' : target);
      case 'scan_discovery':
        return adapter.scanDiscoveryCompleted(
          targetId: target.isEmpty ? 'legacy' : target,
          discoveryId: context['discoveryId'] as String? ?? 'legacy',
        );
      case 'convoy_reach':
        return adapter.enteredRegion(regionId: target.isEmpty ? 'legacy' : target);
      case 'convoy_escort':
        return adapter.convoyEscortTick(
          convoyId: target.isEmpty ? 'legacy' : target,
          integrity: context['integrity'] as num? ?? 100,
        );
      case 'convoy_protect':
        return adapter.convoyProtected(convoyId: target.isEmpty ? 'legacy' : target);
      case 'trade_completed':
        return adapter.tradeCompleted(
          stationId: context['stationId'] as String? ?? 'legacy',
          itemId: context['itemId'] as String? ?? target,
          quantity: amount,
          side: context['side'] as String? ?? 'sell',
        );
      default:
        return null;
    }
  }
}
