import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:void_event_engine/void_event_engine.dart';

void main() {
  test('valid authoring contract passes', () {
    final raw = jsonDecode(File('fixtures/authoring/kairos_signal.json').readAsStringSync()) as Map<String, dynamic>;
    final definition = NarrativeJsonLoader().load(Map<String, dynamic>.from(raw['narrative'] as Map));
    final contract = NarrativeAuthoringContractLoader().load(raw);
    final report = NarrativeAuthoringValidator().validate(
      definition,
      contract,
      knownEventTypes: {'scan.discovery_completed'},
      knownConsequenceTypes: {'evidence.add', 'story.flag'},
    );
    expect(report.hasErrors, isFalse);
  });

  test('invalid namespace and stable ids fail', () {
    final raw = jsonDecode(File('fixtures/authoring/invalid_namespace.json').readAsStringSync()) as Map<String, dynamic>;
    final definition = NarrativeJsonLoader().load(Map<String, dynamic>.from(raw['narrative'] as Map));
    final contract = NarrativeAuthoringContractLoader().load(raw);
    final report = NarrativeAuthoringValidator().validate(definition, contract);
    expect(report.hasErrors, isTrue);
    expect(report.issues.any((i) => i.code == 'invalid_namespace'), isTrue);
  });

  test('authoring unit consumes stage, trait and resonance consequences from catalog', () {
    final catalog = const DomainVocabularyLoader().load(
      jsonDecode(File('vocabulary.catalog.json').readAsStringSync()) as Map<String, dynamic>,
    );
    final raw = jsonDecode(File('fixtures/authoring/lore_main_stage.json').readAsStringSync()) as Map<String, dynamic>;
    final definition = NarrativeJsonLoader().load(Map<String, dynamic>.from(raw['narrative'] as Map));
    final contract = NarrativeAuthoringContractLoader().load(raw);
    final report = NarrativeAuthoringValidator().validate(
      definition,
      contract,
      knownEventTypes: {'flight.entered_region'},
      knownConsequenceTypes: catalog.definitions.map((d) => d.type).toSet(),
    );
    expect(report.hasErrors, isFalse);
    expect(report.referencedConsequences, containsAll(['story.stage', 'trait.add', 'thread.resonance']));
  });
}
