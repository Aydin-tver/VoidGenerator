import '../json_loader.dart';
import 'consequence.dart';

class ConsequenceCatalog {
  const ConsequenceCatalog({required this.schemaVersion, this.rules = const []});
  final int schemaVersion;
  final List<ConsequenceDefinition> rules;
  bool hasRule(String id) => rules.any((r) => r.id == id);
}

class ConsequenceCatalogLoader {
  ConsequenceCatalog load(Map<String, dynamic> json) {
    final rawRules = (json['rules'] as List?) ?? const [];
    return ConsequenceCatalog(
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
      rules: rawRules.map((raw) {
        final map = Map<String, dynamic>.from(raw as Map);
        final event = map['event'] as Map?;
        if (event == null) throw FormatException('Rule ${map['id']} is missing event condition');
        return ConsequenceDefinition(
          id: map['id'] as String,
          eventCondition: ConditionJsonLoader.load(Map<String, dynamic>.from(event)),
          type: map['type'] as String,
          payload: Map<String, Object?>.from(map['payload'] as Map? ?? const {}),
          oncePerEntity: map['oncePerEntity'] as bool? ?? false,
          enabled: map['enabled'] as bool? ?? true,
          priority: (map['priority'] as num?)?.toInt() ?? 0,
          conflictKey: map['conflictKey'] as String?,
          conflictPolicy: _policy(map['conflictPolicy'] as String?),
        );
      }).toList(growable: false),
    );
  }

  static ConsequenceConflictPolicy _policy(String? value) {
    return ConsequenceConflictPolicy.values.firstWhere(
      (p) => p.name == (value ?? ConsequenceConflictPolicy.additive.name),
      orElse: () => throw FormatException('Unknown consequence conflict policy: $value'),
    );
  }
}
