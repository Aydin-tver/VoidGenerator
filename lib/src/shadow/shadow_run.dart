import '../effect.dart';
import '../event.dart';
import '../event_bus.dart';
import '../mission_definition.dart';
import '../mission_runtime.dart';

class ShadowMissionSnapshot {
  const ShadowMissionSnapshot({
    required this.completed,
    this.failed = false,
    this.active = false,
    this.activeStepIds = const [],
    this.progress = const {},
    this.currentOutcomeId,
    this.effects = const [],
  });

  final bool completed;
  final bool failed;
  final bool active;
  final List<String> activeStepIds;
  final Map<String, int> progress;
  final String? currentOutcomeId;
  final List<ShadowEffect> effects;
}

class ShadowEffect {
  const ShadowEffect({required this.outcomeId, required this.type, this.payload = const {}});
  final String outcomeId;
  final String type;
  final Map<String, Object?> payload;

  @override
  bool operator ==(Object other) => other is ShadowEffect &&
      other.outcomeId == outcomeId && other.type == type && _mapEquals(other.payload, payload);

  @override
  int get hashCode => Object.hash(outcomeId, type, payload.toString());
}

class ShadowComparison {
  const ShadowComparison({required this.matches, this.mismatches = const []});
  final bool matches;
  final List<String> mismatches;
}

class ShadowRunStep {
  const ShadowRunStep({required this.event, required this.modern, this.comparison});
  final GameEvent event;
  final ShadowMissionSnapshot modern;
  final ShadowComparison? comparison;
}

class ShadowRunReport {
  const ShadowRunReport({required this.steps});
  final List<ShadowRunStep> steps;

  bool get matches => steps.every((s) => s.comparison?.matches ?? true);
  List<String> get mismatches => [
    for (final step in steps)
      ...?step.comparison?.mismatches.map((m) => '${step.event.id}: $m'),
  ];
}

class ShadowRunSession {
  ShadowRunSession(this.definition, {this.startAt});

  final MissionDefinition definition;
  final DateTime? startAt;
  final EventBus _bus = EventBus();
  late final MissionRuntime runtime = MissionRuntime(
    definition,
    _bus,
    effectHandler: _captureEffect,
  );
  final List<ShadowEffect> _effects = [];
  final List<ShadowRunStep> _steps = [];

  void start() {
    runtime.start(now: startAt ?? DateTime.utc(2000));
    runtime.attach();
  }

  void publish(GameEvent event, {ShadowMissionSnapshot? legacy}) {
    _effects.clear();
    _bus.publish(event);
    final modern = snapshot();
    final comparison = legacy == null ? null : ShadowRunComparator().compare(legacy, modern);
    _steps.add(ShadowRunStep(event: event, modern: modern, comparison: comparison));
  }

  ShadowMissionSnapshot snapshot() => ShadowMissionSnapshot(
    active: runtime.active,
    completed: runtime.completed,
    failed: runtime.failed,
    activeStepIds: runtime.activeStepIds.toList()..sort(),
    progress: Map.unmodifiable(Map.from(runtime.progress)),
    currentOutcomeId: runtime.currentOutcomeId,
    effects: List.unmodifiable(_effects),
  );

  ShadowRunReport report() => ShadowRunReport(steps: List.unmodifiable(_steps));

  ShadowTrace trace() => ShadowTrace(
        missionId: definition.id,
        steps: [
          for (final step in _steps)
            ShadowTraceStep(
              event: step.event,
              snapshot: step.modern,
              matches: step.comparison?.matches,
              mismatches: step.comparison?.mismatches ?? const [],
            ),
        ],
      );

  void dispose() => runtime.detach();

  void _captureEffect(String missionId, String outcomeId, Object effect) {
    if (effect is EffectDefinition) {
      _effects.add(ShadowEffect(outcomeId: outcomeId, type: effect.type, payload: effect.payload));
    }
  }
}

class ShadowRunComparator {
  const ShadowRunComparator();

  ShadowComparison compare(ShadowMissionSnapshot legacy, ShadowMissionSnapshot modern) {
    final mismatches = <String>[];
    if (legacy.completed != modern.completed) mismatches.add('COMPLETION_MISMATCH: legacy=${legacy.completed}, modern=${modern.completed}');
    if (legacy.failed != modern.failed) mismatches.add('FAILURE_MISMATCH: legacy=${legacy.failed}, modern=${modern.failed}');
    if (legacy.active != modern.active) mismatches.add('ACTIVE_MISMATCH: legacy=${legacy.active}, modern=${modern.active}');
    final ids = {...legacy.progress.keys, ...modern.progress.keys};
    for (final id in ids) {
      final a = legacy.progress[id] ?? 0;
      final b = modern.progress[id] ?? 0;
      if (a != b) mismatches.add('PROGRESS_MISMATCH[$id]: legacy=$a, modern=$b');
    }
    final legacySteps = legacy.activeStepIds.toSet();
    final modernSteps = modern.activeStepIds.toSet();
    if (!setEquals(legacySteps, modernSteps)) {
      mismatches.add('ACTIVE_STEPS_MISMATCH: legacy=${_sorted(legacySteps)}, modern=${_sorted(modernSteps)}');
    }
    if (legacy.currentOutcomeId != modern.currentOutcomeId) {
      mismatches.add('OUTCOME_MISMATCH: legacy=${legacy.currentOutcomeId}, modern=${modern.currentOutcomeId}');
    }
    if (!_effectsEqual(legacy.effects, modern.effects)) mismatches.add('EFFECT_MISMATCH');
    return ShadowComparison(matches: mismatches.isEmpty, mismatches: mismatches);
  }

  static bool setEquals(Set<String> a, Set<String> b) => a.length == b.length && a.containsAll(b);
  static List<String> _sorted(Iterable<String> values) => values.toList()..sort();
}

bool _effectsEqual(List<ShadowEffect> a, List<ShadowEffect> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

bool _mapEquals(Map<String, Object?> a, Map<String, Object?> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (!b.containsKey(entry.key) || b[entry.key].toString() != entry.value.toString()) return false;
  }
  return true;
}
