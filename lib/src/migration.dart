import 'mission_definition.dart';

class MissionDefinitionMigrator {
  const MissionDefinitionMigrator();
  MissionDefinition migrate(MissionDefinition input, {required int targetSchemaVersion}) {
    if (input.schemaVersion > targetSchemaVersion) throw StateError('Mission schema ${input.schemaVersion} is newer than target $targetSchemaVersion');
    if (input.schemaVersion == targetSchemaVersion) return input;
    return MissionDefinition(
      schemaVersion: targetSchemaVersion, id: input.id, version: input.version,
      titleKey: input.titleKey, descriptionKey: input.descriptionKey, tags: input.tags,
      prerequisites: input.prerequisites, steps: input.steps, outcomes: input.outcomes, startStepId: input.startStepId,
    );
  }
}
