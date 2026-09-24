import 'dart:convert';
import 'dart:io';

import 'package:void_event_engine/void_event_engine.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart run bin/validate_narrative_authoring.dart <authoring.json> [events.catalog.json] [vocabulary-or-consequences.catalog.json]');
    exitCode = 64;
    return;
  }
  final root = jsonDecode(File(args[0]).readAsStringSync()) as Map<String, dynamic>;
  final narrativeJson = Map<String, dynamic>.from(root['narrative'] as Map);
  final definition = NarrativeJsonLoader().load(narrativeJson);
  final contract = NarrativeAuthoringContractLoader().load(root);
  final events = <String>{};
  if (args.length > 1) {
    final catalog = jsonDecode(File(args[1]).readAsStringSync()) as Map<String, dynamic>;
    for (final e in (catalog['events'] as List? ?? const [])) events.add((e as Map)['type'] as String);
  }
  final consequences = <String>{};
  if (args.length > 2) {
    final catalog = jsonDecode(File(args[2]).readAsStringSync()) as Map<String, dynamic>;
    for (final e in (catalog['definitions'] as List? ?? const [])) consequences.add((e as Map)['type'] as String);
  }
  final report = NarrativeAuthoringValidator().validate(definition, contract, knownEventTypes: events, knownConsequenceTypes: consequences);
  stdout.writeln(jsonEncode(report.toJson()));
  exitCode = report.hasErrors ? 1 : 0;
}
