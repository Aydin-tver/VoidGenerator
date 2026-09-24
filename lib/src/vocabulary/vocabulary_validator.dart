import 'domain_vocabulary.dart';

class VocabularyValidationIssue {
  const VocabularyValidationIssue({required this.code, required this.message, this.error = true});
  final String code;
  final String message;
  final bool error;

  @override
  String toString() => '${error ? 'ERROR' : 'WARN'} [$code] $message';
}

class DomainVocabularyValidator {
  const DomainVocabularyValidator();

  List<VocabularyValidationIssue> validateCatalog(DomainVocabularyCatalog catalog) {
    final issues = <VocabularyValidationIssue>[];
    final ids = <String>{};
    for (final definition in catalog.definitions) {
      if (definition.type.trim().isEmpty) {
        issues.add(const VocabularyValidationIssue(code: 'empty_type', message: 'Vocabulary type is empty'));
      }
      if (!ids.add(definition.type)) {
        issues.add(VocabularyValidationIssue(code: 'duplicate_type', message: 'Duplicate vocabulary type: ${definition.type}'));
      }
      final fields = <String>{};
      for (final field in definition.fields) {
        if (field.name.trim().isEmpty) {
          issues.add(VocabularyValidationIssue(code: 'empty_field', message: '${definition.type}: field name is empty'));
        }
        if (!fields.add(field.name)) {
          issues.add(VocabularyValidationIssue(code: 'duplicate_field', message: '${definition.type}: duplicate field ${field.name}'));
        }
      }
    }
    return List.unmodifiable(issues);
  }

  List<VocabularyValidationIssue> validatePayload(
    DomainVocabularyCatalog catalog,
    String type,
    Map<String, Object?> payload,
  ) {
    final definition = catalog.byType(type);
    if (definition == null) {
      return [VocabularyValidationIssue(code: 'unknown_type', message: 'Unknown vocabulary type: $type')];
    }

    final issues = <VocabularyValidationIssue>[];
    for (final field in definition.fields) {
      if (field.required && !payload.containsKey(field.name)) {
        issues.add(VocabularyValidationIssue(
          code: 'missing_required_field',
          message: '$type: missing required field ${field.name}',
        ));
      }
      if (!payload.containsKey(field.name)) continue;
      final value = payload[field.name];
      if (!_matches(field.type, value)) {
        issues.add(VocabularyValidationIssue(
          code: 'invalid_field_type',
          message: '$type.${field.name}: expected ${field.type.name}, got ${value.runtimeType}',
        ));
      }
    }

    if (definition.strict) {
      for (final key in payload.keys) {
        if (definition.field(key) == null) {
          issues.add(VocabularyValidationIssue(
            code: 'unknown_field',
            message: '$type: unknown payload field $key',
          ));
        }
      }
    }
    return List.unmodifiable(issues);
  }

  bool _matches(VocabularyFieldType type, Object? value) {
    if (value == null) return false;
    switch (type) {
      case VocabularyFieldType.string:
        return value is String;
      case VocabularyFieldType.number:
        return value is num;
      case VocabularyFieldType.boolean:
        return value is bool;
    }
  }
}
