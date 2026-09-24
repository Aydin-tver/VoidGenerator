import 'event.dart';
import 'event_bus.dart';
import 'mission_definition.dart';

class MissionSnapshot {
  const MissionSnapshot({required this.missionId, required this.definitionVersion, required this.active, required this.completed, required this.failed, required this.activeStepIds, required this.progress, required this.startedAt, required this.lastSequence, required this.consumedEventIds});
  final String missionId;
  final int definitionVersion;
  final bool active;
  final bool completed;
  final bool failed;
  final List<String> activeStepIds;
  final Map<String, int> progress;
  final DateTime? startedAt;
  final int? lastSequence;
  final List<String> consumedEventIds;

  Map<String, Object?> toJson() => {
    'missionId': missionId, 'definitionVersion': definitionVersion, 'active': active,
    'completed': completed, 'failed': failed, 'activeStepIds': activeStepIds,
    'progress': progress, 'startedAt': startedAt?.toIso8601String(),
    'lastSequence': lastSequence, 'consumedEventIds': consumedEventIds,
  };
  factory MissionSnapshot.fromJson(Map<String, dynamic> j) => MissionSnapshot(
    missionId: j['missionId'] as String,
    definitionVersion: (j['definitionVersion'] as num).toInt(),
    active: j['active'] as bool,
    completed: j['completed'] as bool,
    failed: j['failed'] as bool? ?? false,
    activeStepIds: (j['activeStepIds'] as List? ?? const []).cast<String>(),
    progress: Map<String, int>.from((j['progress'] as Map? ?? const {}).map((k,v) => MapEntry(k.toString(), (v as num).toInt()))),
    startedAt: j['startedAt'] == null ? null : DateTime.parse(j['startedAt'] as String),
    lastSequence: (j['lastSequence'] as num?)?.toInt(),
    consumedEventIds: (j['consumedEventIds'] as List? ?? const []).cast<String>(),
  );
}

typedef MissionPrerequisiteChecker = bool Function(PrerequisiteDefinition prerequisite);
typedef MissionEffectHandler = void Function(String missionId, String outcomeId, Object effect);
typedef MissionTransitionHandler = void Function(String missionId, String? nextStepId, String? nextMissionId);

class MissionRuntime {
  MissionRuntime(this.definition, this.bus, {this.prerequisiteChecker, this.effectHandler, this.transitionHandler});
  final MissionDefinition definition;
  final EventBus bus;
  final MissionPrerequisiteChecker? prerequisiteChecker;
  final MissionEffectHandler? effectHandler;
  final MissionTransitionHandler? transitionHandler;

  final Map<String, int> progress = {};
  final Map<String, DateTime> stepStartedAt = {};
  final Set<String> activeStepIds = {};
  final Set<String> consumedEventIds = {};
  bool active = false;
  bool completed = false;
  bool failed = false;
  DateTime? startedAt;
  int? lastSequence;
  String? currentOutcomeId;
  DateTime? _clock;

  void start({DateTime? now}) {
    if (definition.prerequisites.any((p) => !(prerequisiteChecker?.call(p) ?? false))) {
      throw StateError('Mission prerequisites are not satisfied: ${definition.id}');
    }
    active = true; completed = false; failed = false; startedAt = now ?? DateTime.utc(2000); _clock = startedAt;
    progress..clear()..addEntries(definition.steps.map((s) => MapEntry(s.id, 0)));
    activeStepIds
      ..clear()
      ..addAll(startStepIds());
    stepStartedAt..clear();
    for (final id in activeStepIds) stepStartedAt[id] = startedAt;
    consumedEventIds.clear(); currentOutcomeId = null; lastSequence = null;
  }

  Iterable<String> startStepIds() {
    if (definition.startStepId != null) return [definition.startStepId!];
    final referenced = definition.steps.map((s) => s.nextStepId).whereType<String>().toSet();
    final starts = definition.steps.where((s) => !referenced.contains(s.id)).map((s) => s.id).toList();
    return starts.isEmpty && definition.steps.isNotEmpty ? [definition.steps.first.id] : starts;
  }

  void dispose() {}

  void attach() {
    final types = definition.steps.map((s) => s.eventCondition.eventType).toSet();
    for (final type in types) bus.subscribe(type, _onEvent);
  }
  void detach() {
    final types = definition.steps.map((s) => s.eventCondition.eventType).toSet();
    for (final type in types) bus.unsubscribe(type, _onEvent);
  }

  void _onEvent(GameEvent event) {
    _clock = event.occurredAt ?? _clock ?? startedAt;
    if (!active || completed || failed || consumedEventIds.contains(event.id)) return;
    lastSequence = event.sequence ?? lastSequence;
    final matched = <MissionStepDefinition>[];
    for (final step in definition.steps) {
      if (!activeStepIds.contains(step.id)) continue;
      if (step.eventCondition.matches(event, const EvaluationContext())) matched.add(step);
    }
    if (matched.isEmpty) return;
    consumedEventIds.add(event.id);
    for (final step in matched) {
      progress[step.id] = ((progress[step.id] ?? 0) + 1).clamp(0, step.count).toInt();
    }
    final completedSteps = matched.where((s) => (progress[s.id] ?? 0) >= s.count).toList();
    for (final step in completedSteps) _completeStep(step);
    _evaluateCompletion();
  }

  void _completeStep(MissionStepDefinition step) {
    activeStepIds.remove(step.id);
    final outcome = step.outcomeId == null ? null : definition.outcomes.where((o) => o.id == step.outcomeId).firstOrNull;
    if (outcome != null) _applyOutcome(outcome);
    if (step.nextStepId != null) { activeStepIds.add(step.nextStepId!); stepStartedAt[step.nextStepId!] = _clock ?? startedAt ?? DateTime.utc(2000); }
  }

  void _applyOutcome(OutcomeDefinition outcome) {
    currentOutcomeId = outcome.id;
    for (final effect in outcome.effects) effectHandler?.call(definition.id, outcome.id, effect);
    if (outcome.nextStepId != null) { activeStepIds.add(outcome.nextStepId!); stepStartedAt[outcome.nextStepId!] = _clock ?? startedAt ?? DateTime.utc(2000); }
    if (outcome.nextMissionId != null) transitionHandler?.call(definition.id, outcome.nextStepId, outcome.nextMissionId);
  }

  void _evaluateCompletion() {
    final mandatory = definition.steps.where((s) => !s.optional);
    if (mandatory.isNotEmpty && mandatory.every((s) => (progress[s.id] ?? 0) >= s.count)) {
      completed = true; active = false;
      transitionHandler?.call(definition.id, null, null);
    }
  }

  void tick(DateTime now) {
    _clock = now;
    if (!active || startedAt == null) return;
    final elapsed = now.difference(startedAt!).inSeconds;
    for (final step in definition.steps.where((s) => activeStepIds.contains(s.id) && s.timeoutSeconds != null)) {
      final activated = stepStartedAt[step.id] ?? startedAt!;
      if (now.difference(activated).inSeconds >= step.timeoutSeconds!) {
        if (step.failOutcomeId != null) { final outcome = definition.outcomes.where((o)=>o.id==step.failOutcomeId).firstOrNull; if(outcome!=null) _applyOutcome(outcome); }
        failed = true; active = false; return;
      }
    }
  }

  MissionSnapshot snapshot() => MissionSnapshot(
    missionId: definition.id, definitionVersion: definition.version, active: active,
    completed: completed, failed: failed, activeStepIds: activeStepIds.toList(), progress: Map.unmodifiable(progress),
    startedAt: startedAt, lastSequence: lastSequence, consumedEventIds: consumedEventIds.toList(),
  );

  void restore(MissionSnapshot snapshot) {
    if (snapshot.missionId != definition.id) throw ArgumentError('Snapshot mission mismatch');
    active = snapshot.active; completed = snapshot.completed; failed = snapshot.failed;
    startedAt = snapshot.startedAt; lastSequence = snapshot.lastSequence;
    progress..clear()..addAll(snapshot.progress);
    activeStepIds..clear()..addAll(snapshot.activeStepIds);
    stepStartedAt..clear();
    for (final id in activeStepIds) stepStartedAt[id] = startedAt ?? DateTime.utc(2000);
    consumedEventIds..clear()..addAll(snapshot.consumedEventIds);
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
