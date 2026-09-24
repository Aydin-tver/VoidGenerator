class ShadowMissionSnapshot {
  const ShadowMissionSnapshot({required this.completed, this.failed = false, this.progress = const {}});
  final bool completed;
  final bool failed;
  final Map<String, int> progress;
}

class ShadowComparison {
  const ShadowComparison({required this.matches, this.mismatches = const []});
  final bool matches;
  final List<String> mismatches;
}

/// Compares legacy and event-engine observable state without importing either
/// game's implementation. The host can feed snapshots after every event.
class ShadowRunComparator {
  const ShadowRunComparator();

  ShadowComparison compare(ShadowMissionSnapshot legacy, ShadowMissionSnapshot modern) {
    final mismatches = <String>[];
    if (legacy.completed != modern.completed) {
      mismatches.add('completion: legacy=${legacy.completed}, modern=${modern.completed}');
    }
    if (legacy.failed != modern.failed) {
      mismatches.add('failure: legacy=${legacy.failed}, modern=${modern.failed}');
    }
    final ids = {...legacy.progress.keys, ...modern.progress.keys};
    for (final id in ids) {
      final a = legacy.progress[id] ?? 0;
      final b = modern.progress[id] ?? 0;
      if (a != b) mismatches.add('progress[$id]: legacy=$a, modern=$b');
    }
    return ShadowComparison(matches: mismatches.isEmpty, mismatches: mismatches);
  }
}
