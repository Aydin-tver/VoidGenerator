import 'condition.dart';
import 'effect.dart';

class MissionDefinition {
  const MissionDefinition({required this.schemaVersion, required this.id, required this.version, required this.titleKey, this.descriptionKey = '', this.tags = const [], this.prerequisites = const [], this.steps = const [], this.outcomes = const [], this.startStepId});
  final int schemaVersion;
  final String id;
  final int version;
  final String titleKey;
  final String descriptionKey;
  final List<String> tags;
  final List<PrerequisiteDefinition> prerequisites;
  final List<MissionStepDefinition> steps;
  final List<OutcomeDefinition> outcomes;
  final String? startStepId;
}

class PrerequisiteDefinition {
  const PrerequisiteDefinition({required this.type, this.value});
  final String type;
  final Object? value;
}

class MissionStepDefinition {
  const MissionStepDefinition({required this.id, required this.eventCondition, this.count = 1, this.displayKey = '', this.locationKey = '', this.clueKey = '', this.sourceKey = '', this.optional = false, this.timeoutSeconds, this.nextStepId, this.outcomeId, this.failOutcomeId});
  final String id;
  final Condition eventCondition;
  final int count;
  final String displayKey;
  final String locationKey;
  final String clueKey;
  final String sourceKey;
  final bool optional;
  final int? timeoutSeconds;
  final String? nextStepId;
  final String? outcomeId;
  final String? failOutcomeId;
}

class OutcomeDefinition {
  const OutcomeDefinition({required this.id, this.effects = const [], this.nextStepId, this.nextMissionId, this.terminal = false});
  final String id;
  final List<EffectDefinition> effects;
  final String? nextStepId;
  final String? nextMissionId;
  final bool terminal;
}
