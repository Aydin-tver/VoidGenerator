import 'narrative.dart';

class NarrativeValidationIssue {
  const NarrativeValidationIssue(this.path, this.message);
  final String path;
  final String message;
  @override String toString() => '$path: $message';
}

class NarrativeValidator {
  List<NarrativeValidationIssue> validate(NarrativeDefinition definition) {
    final issues = <NarrativeValidationIssue>[];
    final ids = <String>{};
    for (final node in definition.nodes) {
      if (!ids.add(node.id)) issues.add(NarrativeValidationIssue('nodes.${node.id}', 'duplicate node id'));
      if (node.id.trim().isEmpty) issues.add(const NarrativeValidationIssue('nodes', 'empty node id'));
      for (final choice in node.choices) {
        if (definition.node(choice.targetNodeId) == null) issues.add(NarrativeValidationIssue('nodes.${node.id}.choices.${choice.id}', 'unknown target node ${choice.targetNodeId}'));
        if (choice.id.trim().isEmpty) issues.add(NarrativeValidationIssue('nodes.${node.id}.choices', 'empty choice id'));
      }
      if (node.autoTargetNodeId != null && definition.node(node.autoTargetNodeId!) == null) issues.add(NarrativeValidationIssue('nodes.${node.id}.autoTargetNodeId', 'unknown target node ${node.autoTargetNodeId}'));
      if (node.enterEventType == null && node.autoTargetNodeId != null) issues.add(NarrativeValidationIssue('nodes.${node.id}', 'auto transition without an enter event may create an immediate loop'));
    }
    if (definition.node(definition.startNodeId) == null) issues.add(NarrativeValidationIssue('startNodeId', 'unknown start node ${definition.startNodeId}'));
    if (definition.nodes.where((n) => n.terminal).isEmpty) issues.add(const NarrativeValidationIssue('nodes', 'no terminal node'));
    return issues;
  }
}
