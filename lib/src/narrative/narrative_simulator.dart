import 'narrative.dart';

class NarrativeSimulationResult {
  const NarrativeSimulationResult({required this.nodeIds, required this.consequences, required this.completed});
  final List<String> nodeIds;
  final List<String> consequences;
  final bool completed;
}

class NarrativeSimulator {
  NarrativeSimulationResult followChoices(NarrativeDefinition definition, List<String> choiceIds, {NarrativeState state = const NarrativeState()}) {
    final consequences = <String>[];
    final nodes = <String>[];
    final runtime = NarrativeRuntime(definition, consequenceHandler: (_, __, type, ___) => consequences.add(type));
    runtime.start(state: state);
    nodes.add(runtime.currentNodeId!);
    for (final choiceId in choiceIds) {
      runtime.choose(choiceId, state);
      nodes.add(runtime.currentNodeId!);
      if (runtime.completed) break;
    }
    return NarrativeSimulationResult(nodeIds: nodes, consequences: consequences, completed: runtime.completed);
  }
}
