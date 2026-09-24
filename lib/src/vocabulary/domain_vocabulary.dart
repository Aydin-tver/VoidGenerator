/// Canonical, game-neutral consequence vocabulary.
///
/// The vocabulary defines names and payload contracts only. It does not own
/// WorldState, StoryState, FactionState, CharacterState, Economy or any other
/// authoritative game state.
class DomainVocabulary {
  const DomainVocabulary._();

  static const worldConsequence = 'world.consequence';
  static const factionReputation = 'faction.reputation';
  static const characterTrust = 'character.trust';
  static const storyFlag = 'story.flag';
  static const evidenceAdd = 'evidence.add';
  static const economyTelemetry = 'economy.telemetry';
  static const threadResonance = 'thread.resonance';

  static const all = <String>[
    worldConsequence,
    factionReputation,
    characterTrust,
    storyFlag,
    evidenceAdd,
    economyTelemetry,
    threadResonance,
  ];
}

enum VocabularyFieldType { string, number, boolean }

class VocabularyField {
  const VocabularyField({required this.name, required this.type, this.required = true});
  final String name;
  final VocabularyFieldType type;
  final bool required;

  Map<String, Object?> toJson() => {
        'type': type.name,
        'required': required,
      };
}

class DomainVocabularyDefinition {
  const DomainVocabularyDefinition({required this.type, required this.fields, this.strict = true});
  final String type;
  final List<VocabularyField> fields;
  final bool strict;

  VocabularyField? field(String name) {
    for (final field in fields) {
      if (field.name == name) return field;
    }
    return null;
  }

  Map<String, Object?> toJson() => {
        'type': type,
        'strict': strict,
        'payload': {for (final field in fields) field.name: field.toJson()},
      };
}

class DomainVocabularyCatalog {
  const DomainVocabularyCatalog({required this.schemaVersion, required this.definitions});
  final int schemaVersion;
  final List<DomainVocabularyDefinition> definitions;

  DomainVocabularyDefinition? byType(String type) {
    for (final definition in definitions) {
      if (definition.type == type) return definition;
    }
    return null;
  }

  bool contains(String type) => byType(type) != null;

  Map<String, Object?> toJson() => {
        'schemaVersion': schemaVersion,
        'definitions': definitions.map((d) => d.toJson()).toList(growable: false),
      };
}

class DomainVocabularyDefaults {
  const DomainVocabularyDefaults._();

  static const catalog = DomainVocabularyCatalog(
    schemaVersion: 1,
    definitions: [
      DomainVocabularyDefinition(
        type: DomainVocabulary.worldConsequence,
        fields: [
          VocabularyField(name: 'key', type: VocabularyFieldType.string),
          VocabularyField(name: 'delta', type: VocabularyFieldType.number),
        ],
      ),
      DomainVocabularyDefinition(
        type: DomainVocabulary.factionReputation,
        fields: [
          VocabularyField(name: 'factionId', type: VocabularyFieldType.string),
          VocabularyField(name: 'delta', type: VocabularyFieldType.number),
        ],
      ),
      DomainVocabularyDefinition(
        type: DomainVocabulary.characterTrust,
        fields: [
          VocabularyField(name: 'characterId', type: VocabularyFieldType.string),
          VocabularyField(name: 'delta', type: VocabularyFieldType.number),
        ],
      ),
      DomainVocabularyDefinition(
        type: DomainVocabulary.storyFlag,
        fields: [
          VocabularyField(name: 'flag', type: VocabularyFieldType.string),
          VocabularyField(name: 'value', type: VocabularyFieldType.boolean),
        ],
      ),
      DomainVocabularyDefinition(
        type: DomainVocabulary.evidenceAdd,
        fields: [
          VocabularyField(name: 'evidenceId', type: VocabularyFieldType.string),
        ],
      ),
      DomainVocabularyDefinition(
        type: DomainVocabulary.economyTelemetry,
        fields: [
          VocabularyField(name: 'metric', type: VocabularyFieldType.string),
          VocabularyField(name: 'amount', type: VocabularyFieldType.number),
        ],
      ),
      DomainVocabularyDefinition(
        type: DomainVocabulary.threadResonance,
        fields: [
          VocabularyField(name: 'delta', type: VocabularyFieldType.number),
          VocabularyField(name: 'source', type: VocabularyFieldType.string, required: false),
        ],
      ),
    ],
  );
}
