import 'narrative.dart';

class NarrativeJsonLoader {
  NarrativeDefinition load(Map<String,dynamic> json) {
    final nodes = ((json['nodes'] as List?) ?? const []).map((raw) {
      final m = Map<String,dynamic>.from(raw as Map);
      final choices = ((m['choices'] as List?) ?? const []).map((rawChoice) {
        final c = Map<String,dynamic>.from(rawChoice as Map);
        return NarrativeChoice(id: c['id'] as String, targetNodeId: c['targetNodeId'] as String, condition: NarrativeConditionJsonLoader.load(c['condition'] as Map? ?? const {}), consequenceTypes: ((c['consequences'] as List?) ?? const []).cast<String>(), tags: ((c['tags'] as List?) ?? const []).cast<String>());
      }).toList();
      return NarrativeNode(id: m['id'] as String, textKey: m['textKey'] as String? ?? '', enterEventType: m['enterEventType'] as String?, autoTargetNodeId: m['autoTargetNodeId'] as String?, terminal: m['terminal'] as bool? ?? false, choices: choices, enterConsequences: ((m['enterConsequences'] as List?) ?? const []).cast<String>(), tags: ((m['tags'] as List?) ?? const []).cast<String>());
    }).toList();
    return NarrativeDefinition(id: json['id'] as String, version: (json['version'] as num?)?.toInt() ?? 1, startNodeId: json['startNodeId'] as String, nodes: nodes, tags: ((json['tags'] as List?) ?? const []).cast<String>());
  }
}

class NarrativeConditionJsonLoader {
  static NarrativeCondition load(Map json) {
    final op = json['op'];
    switch (op) {
      case 'flag': return FlagNarrativeCondition(json['id'] as String, expected: json['expected'] as bool? ?? true);
      case 'value': return ValueNarrativeCondition(json['id'] as String, equals: json['equals'] as num?, greaterThan: json['greaterThan'] as num?, lessThan: json['lessThan'] as num?);
      case 'fact': return FactNarrativeCondition(json['id'] as String, expected: json['expected'] as bool? ?? true);
      case 'all': return AllNarrativeCondition(((json['conditions'] as List?) ?? const []).map((e) => load(Map.from(e as Map))).toList());
      case 'any': return AnyNarrativeCondition(((json['conditions'] as List?) ?? const []).map((e) => load(Map.from(e as Map))).toList());
      case 'not': return NotNarrativeCondition(load(Map.from(json['condition'] as Map)));
      default: return const AlwaysNarrativeCondition();
    }
  }
}
