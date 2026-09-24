import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:void_event_engine/void_event_engine.dart';

void main() {
  test('default vocabulary contains all canonical types', () {
    expect(DomainVocabularyDefaults.catalog.definitions.length, 9);
    for (final type in DomainVocabulary.all) {
      expect(DomainVocabularyDefaults.catalog.contains(type), isTrue, reason: type);
    }
  });

  test('catalog JSON matches default contract set', () {
    final file = File('vocabulary.catalog.json');
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final catalog = const DomainVocabularyLoader().load(json);
    final issues = const DomainVocabularyValidator().validateCatalog(catalog);
    expect(issues, isEmpty);
    expect(catalog.definitions.map((d) => d.type), containsAll(DomainVocabulary.all));
  });

  test('valid payload fixture passes every contract', () {
    final catalog = const DomainVocabularyLoader().load(
      jsonDecode(File('vocabulary.catalog.json').readAsStringSync()) as Map<String, dynamic>,
    );
    final fixture = jsonDecode(File('fixtures/vocabulary/valid.json').readAsStringSync()) as Map<String, dynamic>;
    final validator = const DomainVocabularyValidator();
    for (final entry in fixture.entries) {
      final issues = validator.validatePayload(
        catalog,
        entry.key,
        Map<String, Object?>.from(entry.value as Map),
      );
      expect(issues, isEmpty, reason: entry.key);
    }
  });

  test('strict contract rejects missing, wrong and unknown fields', () {
    final catalog = DomainVocabularyDefaults.catalog;
    final validator = const DomainVocabularyValidator();
    final issues = validator.validatePayload(
      catalog,
      DomainVocabulary.factionReputation,
      {'factionId': 42, 'delta': 'five', 'unexpected': true},
    );
    expect(issues.map((issue) => issue.code), contains('invalid_field_type'));
    expect(issues.map((issue) => issue.code), contains('unknown_field'));
  });
}
