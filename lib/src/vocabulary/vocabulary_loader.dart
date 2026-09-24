class DomainVocabularyLoader {
  const DomainVocabularyLoader();

  DomainVocabularyCatalog load(Map<String, dynamic> json) {
    final rawDefinitions = (json['definitions'] as List?) ?? const [];
    final definitions = rawDefinitions.map((raw) {
      final map = Map<String, dynamic>.from(raw as Map);
      final rawPayload = Map<String, dynamic>.from(map['payload'] as Map? ?? const {});
      return DomainVocabularyDefinition(
        type: map['type'] as String,
        strict: map['strict'] as bool? ?? true,
        fields: rawPayload.entries.map((entry) {
          final field = Map<String, dynamic>.from(entry.value as Map);
          return VocabularyField(
            name: entry.key,
            type: VocabularyFieldType.values.firstWhere(
              (value) => value.name == field['type'],
              orElse: () => throw FormatException('Unknown vocabulary field type: ${field['type']}'),
            ),
            required: field['required'] as bool? ?? true,
          );
        }).toList(growable: false),
      );
    }).toList(growable: false);
    return DomainVocabularyCatalog(
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
      definitions: definitions,
    );
  }
}
