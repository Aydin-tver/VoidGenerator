import 'shadow_run.dart';

class ShadowMismatch {
  const ShadowMismatch({required this.eventId, required this.category, required this.message});
  final String eventId;
  final String category;
  final String message;
}

class ShadowReportSummary {
  const ShadowReportSummary({required this.totalEvents, required this.matchedEvents, required this.mismatches});
  final int totalEvents;
  final int matchedEvents;
  final List<ShadowMismatch> mismatches;

  int get mismatchCount => mismatches.length;
  Map<String, int> get byCategory {
    final result = <String, int>{};
    for (final item in mismatches) result[item.category] = (result[item.category] ?? 0) + 1;
    return result;
  }

  Map<String, Object?> toJson() => {
    'totalEvents': totalEvents,
    'matchedEvents': matchedEvents,
    'mismatchCount': mismatchCount,
    'byCategory': byCategory,
    'mismatches': mismatches.map((m) => {'eventId': m.eventId, 'category': m.category, 'message': m.message}).toList(),
  };
}

class ShadowReportBuilder {
  const ShadowReportBuilder();

  ShadowReportSummary build(ShadowRunReport report) {
    final mismatches = <ShadowMismatch>[];
    var matched = 0;
    for (final step in report.steps) {
      final comparison = step.comparison;
      if (comparison == null || comparison.matches) {
        matched++;
        continue;
      }
      for (final raw in comparison.mismatches) {
        final category = _category(raw);
        mismatches.add(ShadowMismatch(eventId: step.event.id, category: category, message: raw));
      }
    }
    return ShadowReportSummary(totalEvents: report.steps.length, matchedEvents: matched, mismatches: List.unmodifiable(mismatches));
  }

  String _category(String value) {
    if (value.startsWith('COMPLETION_MISMATCH')) return 'COMPLETION_MISMATCH';
    if (value.startsWith('FAILURE_MISMATCH')) return 'FAILURE_MISMATCH';
    if (value.startsWith('PROGRESS_MISMATCH')) return 'PROGRESS_MISMATCH';
    if (value.startsWith('EFFECT_MISMATCH')) return 'EFFECT_MISMATCH';
    if (value.startsWith('ACTIVE_STEPS_MISMATCH')) return 'ACTIVE_STEPS_MISMATCH';
    if (value.startsWith('OUTCOME_MISMATCH')) return 'OUTCOME_MISMATCH';
    return 'STATE_MISMATCH';
  }
}
