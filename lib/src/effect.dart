/// Declarative effect produced by a mission outcome. The host game maps effect
/// types to actual use cases. The event engine never imports game-specific code.
class EffectDefinition {
  const EffectDefinition({required this.type, this.payload = const {}});
  final String type;
  final Map<String, Object?> payload;
}
