/// Controls which mission runtime is authoritative during migration.
enum MissionAuthorityMode {
  legacy,
  shadow,
  modern,
}

class MissionAuthorityDecision {
  const MissionAuthorityDecision({required this.mode, required this.applyModernEffects});

  final MissionAuthorityMode mode;
  /// Modern effects are never applied in [shadow] mode.
  final bool applyModernEffects;
}

class MissionAuthorityCoordinator {
  const MissionAuthorityCoordinator(this.mode);

  final MissionAuthorityMode mode;

  MissionAuthorityDecision get decision => MissionAuthorityDecision(
        mode: mode,
        applyModernEffects: mode == MissionAuthorityMode.modern,
      );
}
