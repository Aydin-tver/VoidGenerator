import 'dart:convert';
import 'dart:io';

import 'package:void_event_engine/void_event_engine.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart run bin/validate_narratives.dart <story.json> [events.catalog.json] [vocabulary.catalog.json]');
    exitCode = 64;
    return;
  }
  final story = jsonDecode(File(args[0]).readAsStringSync()) as Map<String, dynamic>;
  final definition = NarrativeJsonLoader().load(story);
  final eventTypes = <String>{};
  if (args.length > 1) {
    final catalog = jsonDecode(File(args[1]).readAsStringSync()) as Map<String, dynamic>;
    for (final e in (catalog['events'] as List? ?? const [])) {
      eventTypes.add((e as Map)['type'] as String);
    }
  }
  final consequenceTypes = <String>{};
  if (args.length > 2) {
    final catalog = jsonDecode(File(args[2]).readAsStringSync()) as Map<String, dynamic>;
    for (final e in (catalog['definitions'] as List? ?? const [])) {
      consequenceTypes.add((e as Map)['type'] as String);
    }
  }
  final report = NarrativeContentToolchain().analyze(
    definition,
    knownEventTypes: eventTypes,
    knownConsequenceTypes: consequenceTypes,
  );
  stdout.writeln(jsonEncode(report.toJson()));
  exitCode = report.hasErrors ? 1 : 0;
}
