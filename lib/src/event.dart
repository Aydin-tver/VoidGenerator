/// Immutable fact emitted by the game. Events describe what happened; they do
/// not contain commands and should not directly mutate game state.
class GameEvent {
  const GameEvent({
    required this.id,
    required this.type,
    required this.version,
    required this.payload,
    this.tags = const <String>[],
    this.source = '',
    this.entityId,
    this.correlationId,
    this.causationId,
    this.sequence,
    this.occurredAt,
  });

  final String id;
  final String type;
  final int version;
  final Map<String, Object?> payload;
  final List<String> tags;
  final String source;
  final String? entityId;
  final String? correlationId;
  final String? causationId;
  final int? sequence;
  final DateTime? occurredAt;

  Object? operator [](String key) => payload[key];

  bool hasTag(String tag) => tags.contains(tag);
}

/// Separate command from fact. Commands ask the game to do something; an
/// accepted command should produce one or more GameEvents.
class GameCommand {
  const GameCommand({required this.type, this.payload = const {}, this.source = ''});
  final String type;
  final Map<String, Object?> payload;
  final String source;
}
