/// Boundary between narrative state and authoritative Wanderers systems.
///
/// Implement this interface against the actual project services. Narrative
/// code should not directly reach credits, cargo, combat or travel internals.
abstract interface class NarrativeHostAdapter {
  bool hasCapability(String capability, int minimumLevel);

  void requestNarrativeMissionUnlock(String missionId);

  void requestDialogueRefresh(String characterId);

  void requestStationNarrativeState(String stationId, String state);
}
