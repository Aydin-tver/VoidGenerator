import '../narrative/narrative.dart';
import 'narrative_authoring.dart';

class AuthoringIssue {
  const AuthoringIssue(this.severity, this.code, this.path, this.message);
  final AuthoringSeverity severity;
  final String code;
  final String path;
  final String message;
  @override
  String toString() => '${severity.name.toUpperCase()} $code $path: $message';
}

enum AuthoringSeverity { error, warning }

class AuthoringReport {
  const AuthoringReport(this.issues, {this.referencedEvents = const {}, this.referencedConsequences = const {}, this.referencedLocalizationKeys = const {}});
  final List<AuthoringIssue> issues;
  final Set<String> referencedEvents;
  final Set<String> referencedConsequences;
  final Set<String> referencedLocalizationKeys;
  bool get hasErrors => issues.any((i) => i.severity == AuthoringSeverity.error);
  int get errors => issues.where((i) => i.severity == AuthoringSeverity.error).length;
  int get warnings => issues.where((i) => i.severity == AuthoringSeverity.warning).length;
  Map<String, Object?> toJson() => {
    'errors': errors,
    'warnings': warnings,
    'referencedEvents': referencedEvents.toList()..sort(),
    'referencedConsequences': referencedConsequences.toList()..sort(),
    'referencedLocalizationKeys': referencedLocalizationKeys.toList()..sort(),
    'issues': issues.map((i) => {'severity': i.severity.name, 'code': i.code, 'path': i.path, 'message': i.message}).toList(),
  };
}

class NarrativeAuthoringValidator {
  const NarrativeAuthoringValidator();

  AuthoringReport validate(
    NarrativeDefinition definition,
    NarrativeAuthoringContract contract, {
    Set<String> knownEventTypes = const {},
    Set<String> knownConsequenceTypes = const {},
    Set<String> knownNarrativeIds = const {},
  }) {
    final issues = <AuthoringIssue>[];
    final events = <String>{};
    final consequences = <String>{};
    final localization = <String>{};
    void error(String code, String path, String message) => issues.add(AuthoringIssue(AuthoringSeverity.error, code, path, message));
    void warning(String code, String path, String message) => issues.add(AuthoringIssue(AuthoringSeverity.warning, code, path, message));

    if (contract.schemaVersion != 1) error('unsupported_schema', 'schemaVersion', 'expected authoring schema version 1');
    if (contract.contractVersion != 1) error('unsupported_contract', 'contractVersion', 'expected authoring contract version 1');
    if (contract.contentId.trim().isEmpty) error('missing_content_id', 'contentId', 'contentId is required');
    if (contract.storyId != definition.id) error('story_mismatch', 'storyId', 'contract storyId ${contract.storyId} does not match definition ${definition.id}');
    if (contract.version != definition.version) error('version_mismatch', 'version', 'contract version ${contract.version} does not match definition ${definition.version}');
    if (contract.owner.trim().isEmpty) error('missing_owner', 'owner.agentId', 'every content unit must declare an owner');
    if (contract.sourcePath.trim().isEmpty) error('missing_source', 'source.path', 'source path is required for reproducible authoring');
    if (!_validNamespace(contract.namespace)) error('invalid_namespace', 'namespace', 'namespace must contain only lowercase letters, digits, dots, underscores or hyphens');
    if (contract.nodeIdPrefix.trim().isEmpty) error('missing_node_prefix', 'stableIds.nodePrefix', 'node ID prefix is required');
    if (contract.choiceIdPrefix.trim().isEmpty) error('missing_choice_prefix', 'stableIds.choicePrefix', 'choice ID prefix is required');
    if (!contract.storyId.startsWith('${contract.namespace}.') && contract.namespace != contract.storyId) {
      error('story_outside_namespace', 'storyId', 'storyId must be inside declared namespace ${contract.namespace}');
    }

    _checkUnique(contract.eventDependencies, 'dependencies.events', error, 'duplicate_dependency');
    _checkUnique(contract.consequenceDependencies, 'dependencies.consequences', error, 'duplicate_dependency');
    _checkUnique(contract.narrativeDependencies, 'dependencies.narratives', error, 'duplicate_dependency');
    if (contract.narrativeDependencies.contains(definition.id)) error('self_dependency', 'dependencies.narratives', 'narrative cannot depend on itself');
    for (final id in contract.narrativeDependencies) {
      if (knownNarrativeIds.isNotEmpty && !knownNarrativeIds.contains(id)) error('unknown_narrative_dependency', 'dependencies.narratives', 'narrative $id is not in the known content index');
    }

    final declaredLoc = contract.localizationKeys.toSet();
    if (declaredLoc.length != contract.localizationKeys.length) error('duplicate_localization_key', 'localization.keys', 'localization keys must be unique');

    for (final node in definition.nodes) {
      if (!node.id.startsWith(contract.nodeIdPrefix)) error('unstable_node_id', 'nodes.${node.id}', 'node id must start with ${contract.nodeIdPrefix}');
      if (node.textKey.trim().isEmpty) error('missing_localization_key', 'nodes.${node.id}.textKey', 'node textKey is required');
      else {
        localization.add(node.textKey);
        if (!declaredLoc.contains(node.textKey)) error('undeclared_localization_key', 'nodes.${node.id}.textKey', 'textKey ${node.textKey} is not declared in localization.keys');
      }
      if (node.enterEventType != null) events.add(node.enterEventType!);
      consequences.addAll(node.enterConsequences);
      for (final choice in node.choices) {
        if (!choice.id.startsWith(contract.choiceIdPrefix)) error('unstable_choice_id', 'nodes.${node.id}.choices.${choice.id}', 'choice id must start with ${contract.choiceIdPrefix}');
        consequences.addAll(choice.consequenceTypes);
      }
    }

    for (final key in declaredLoc.difference(localization)) warning('unused_localization_key', 'localization.keys', 'declared localization key $key is not referenced by any node');
    for (final event in events) {
      if (!contract.eventDependencies.contains(event)) error('undeclared_event_dependency', 'dependencies.events', 'event $event is used but not declared');
      if (knownEventTypes.isNotEmpty && !knownEventTypes.contains(event)) error('unknown_event', 'dependencies.events', 'event $event is not in the event catalog');
    }
    for (final event in contract.eventDependencies) {
      if (knownEventTypes.isNotEmpty && !knownEventTypes.contains(event)) error('unknown_event_dependency', 'dependencies.events', 'declared event $event is not in the event catalog');
    }
    for (final consequence in consequences) {
      if (!contract.consequenceDependencies.contains(consequence)) error('undeclared_consequence_dependency', 'dependencies.consequences', 'consequence $consequence is used but not declared');
      if (knownConsequenceTypes.isNotEmpty && !knownConsequenceTypes.contains(consequence)) error('unknown_consequence', 'dependencies.consequences', 'consequence $consequence is not in the consequence catalog');
    }
    for (final consequence in contract.consequenceDependencies) {
      if (knownConsequenceTypes.isNotEmpty && !knownConsequenceTypes.contains(consequence)) error('unknown_consequence_dependency', 'dependencies.consequences', 'declared consequence $consequence is not in the consequence catalog');
    }
    if (contract.eventDependencies.toSet().difference(events).isNotEmpty) warning('unused_event_dependency', 'dependencies.events', 'one or more declared events are not referenced by this narrative unit');
    if (contract.consequenceDependencies.toSet().difference(consequences).isNotEmpty) warning('unused_consequence_dependency', 'dependencies.consequences', 'one or more declared consequences are not referenced by this narrative unit');

    return AuthoringReport(issues, referencedEvents: events, referencedConsequences: consequences, referencedLocalizationKeys: localization);
  }

  bool _validNamespace(String value) => RegExp(r'^[a-z0-9]+(?:[._-][a-z0-9]+)*$').hasMatch(value);
  void _checkUnique(List<String> values, String path, void Function(String, String, String) add, String code) {
    final seen = <String>{};
    for (final value in values) if (!seen.add(value)) add(code, path, 'duplicate dependency $value');
  }
}
