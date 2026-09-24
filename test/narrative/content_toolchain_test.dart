import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:void_event_engine/void_event_engine.dart';

void main() {
  test('validates reachable graph and contracts', () {
    final story = jsonDecode(File('fixtures/narrative/branching_story.json').readAsStringSync()) as Map<String, dynamic>;
    final definition = NarrativeJsonLoader().load(story);
    final report = NarrativeContentToolchain().analyze(
      definition,
      knownEventTypes: {'flight.entered_region'},
      knownConsequenceTypes: {'character.trust', 'evidence.add', 'story.flag'},
    );
    expect(report.hasErrors, isFalse);
    expect(report.reachableNodeIds, containsAll(<String>{'briefing','contact','investigation','ending'}));
    expect(report.terminalNodeIds, contains('ending'));
  });

  test('finds unreachable nodes, unknown targets and impossible conditions', () {
    final story = jsonDecode(File('fixtures/narrative/invalid_story.json').readAsStringSync()) as Map<String, dynamic>;
    final definition = NarrativeJsonLoader().load(story);
    final report = NarrativeContentToolchain().analyze(
      definition,
      knownEventTypes: {'known.event'},
      knownConsequenceTypes: {'known.consequence'},
    );
    expect(report.hasErrors, isTrue);
    expect(report.issues.any((i) => i.code == 'unknown_target'), isTrue);
    expect(report.issues.any((i) => i.code == 'unreachable_node'), isTrue);
    expect(report.issues.any((i) => i.code == 'impossible_condition'), isTrue);
  });
}
