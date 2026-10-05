// Stage 31 production pseudocode.
// Adapt names to the existing Wanderers architecture.

class FerrumSystemicRuntime {
  void onDomainEvent(DomainEvent event) {
    final narrativeEvents = adapter.translate(event);

    for (final narrativeEvent in narrativeEvents) {
      narrativeRuntime.consume(narrativeEvent);
    }

    worldSimulation.recalculateRelevantConsequences(event);
  }

  void performPlayerAction(PlayerAction action) {
    final result = authoritativeActions.execute(action);

    // Never fake success here.
    // Unsupported capability => explicit failure/risk state.

    if (result.events.isNotEmpty) {
      for (final event in result.events) {
        onDomainEvent(event);
      }
    }
  }
}
