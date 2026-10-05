class NarrativeState {
  final Map<String, KnowledgeEntry> knowledge = {};
  final Map<String, FactionStoryState> factions = {};
  final Map<String, NpcMemoryState> npcs = {};
  final Map<String, String> stationStates = {};
  final Set<String> appliedEffectKeys = {};

  bool hasKnowledge(String id) => knowledge.containsKey(id);

  bool effectApplied(String key) => appliedEffectKeys.contains(key);

  void markEffectApplied(String key) => appliedEffectKeys.add(key);
}

class KnowledgeEntry {
  KnowledgeEntry({
    required this.id,
    required this.state,
    this.sources = const <String>[],
  });

  final String id;
  String state;
  final List<String> sources;
}

class FactionStoryState {
  int reputation;
  int trust;

  FactionStoryState({this.reputation = 0, this.trust = 0});
}

class NpcMemoryState {
  int trust;
  final Set<String> memories;

  NpcMemoryState({this.trust = 0, Set<String>? memories})
      : memories = memories ?? <String>{};
}
