import '../condition.dart';
import 'consequence.dart';
import 'consequence_catalog.dart';

class ConsequenceValidationIssue {
  const ConsequenceValidationIssue({required this.code, required this.message, this.error = true});
  final String code;
  final String message;
  final bool error;
  @override
  String toString() => '${error ? 'ERROR' : 'WARN'} [$code] $message';
}

class ConsequenceValidator {
  const ConsequenceValidator();

  List<ConsequenceValidationIssue> validate(ConsequenceCatalog catalog) {
    final issues = <ConsequenceValidationIssue>[];
    final ids = <String>{};
    final conflictPolicies = <String, ConsequenceConflictPolicy>{};
    for (final rule in catalog.rules) {
      if (rule.id.trim().isEmpty) issues.add(const ConsequenceValidationIssue(code: 'empty_id', message: 'Consequence rule id is empty'));
      if (!ids.add(rule.id)) issues.add(ConsequenceValidationIssue(code: 'duplicate_id', message: 'Duplicate consequence rule id: ${rule.id}'));
      if (rule.type.trim().isEmpty) issues.add(ConsequenceValidationIssue(code: 'empty_type', message: '${rule.id}: consequence type is empty'));
      if (rule.eventCondition is EventCondition && (rule.eventCondition as EventCondition).eventType.trim().isEmpty) {
        issues.add(ConsequenceValidationIssue(code: 'empty_event_type', message: '${rule.id}: event type is empty'));
      }
      final key = rule.conflictKey;
      if (key != null && key.trim().isEmpty) issues.add(ConsequenceValidationIssue(code: 'empty_conflict_key', message: '${rule.id}: conflictKey is empty'));
      if (key != null) {
        final previous = conflictPolicies[key];
        if (previous != null && previous != rule.conflictPolicy) {
          issues.add(ConsequenceValidationIssue(code: 'conflict_policy_mismatch', message: '$key uses both ${previous.name} and ${rule.conflictPolicy.name}'));
        } else {
          conflictPolicies[key] = rule.conflictPolicy;
        }
      }
      if (rule.oncePerEntity && !rule.enabled) {
        issues.add(ConsequenceValidationIssue(code: 'disabled_once_rule', message: '${rule.id}: disabled rule is marked oncePerEntity', error: false));
      }
    }
    return List.unmodifiable(issues);
  }
}
