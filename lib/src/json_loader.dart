import 'condition.dart';
import 'effect.dart';
import 'mission_definition.dart';

class MissionJsonLoader {
  MissionDefinition load(Map<String, dynamic> json) {
    final steps = ((json['steps'] as List?) ?? const []).map((raw) {
      final map = Map<String, dynamic>.from(raw as Map);
      return MissionStepDefinition(
        id: map['id'] as String,
        count: (map['count'] as num?)?.toInt() ?? 1,
        displayKey: map['displayKey'] as String? ?? '', locationKey: map['locationKey'] as String? ?? '',
        clueKey: map['clueKey'] as String? ?? '', sourceKey: map['sourceKey'] as String? ?? '',
        optional: map['optional'] as bool? ?? false, timeoutSeconds: (map['timeoutSeconds'] as num?)?.toInt(),
        nextStepId: map['nextStepId'] as String?, outcomeId: map['outcomeId'] as String?, failOutcomeId: map['failOutcomeId'] as String?,
        eventCondition: ConditionJsonLoader.load(Map<String,dynamic>.from(map['event'] as Map)),
      );
    }).toList();
    final outcomes = ((json['outcomes'] as List?) ?? const []).map((raw) {
      final map = Map<String,dynamic>.from(raw as Map);
      final effects = ((map['effects'] as List?) ?? const []).map((e) { final em=Map<String,dynamic>.from(e as Map); return EffectDefinition(type: em['type'] as String, payload: Map<String,Object?>.from(em['payload'] as Map? ?? const {})); }).toList();
      return OutcomeDefinition(id: map['id'] as String, nextStepId: map['nextStepId'] as String?, nextMissionId: map['nextMissionId'] as String?, terminal: map['terminal'] as bool? ?? false, effects: effects);
    }).toList();
    final prerequisites = ((json['prerequisites'] as List?) ?? const []).map((raw) { final map=Map<String,dynamic>.from(raw as Map); return PrerequisiteDefinition(type: map['type'] as String, value: map['value']); }).toList();
    return MissionDefinition(schemaVersion:(json['schemaVersion'] as num?)?.toInt()??1, id:json['id'] as String, version:(json['version'] as num?)?.toInt()??1, titleKey:json['titleKey'] as String, descriptionKey:json['descriptionKey'] as String? ?? '', tags:((json['tags'] as List?)??const[]).cast<String>(), prerequisites:prerequisites, startStepId:json['startStepId'] as String?, steps:steps, outcomes:outcomes);
  }
}

class ConditionJsonLoader {
  static Condition load(Map<String,dynamic> json) {
    final op=json['op'];
    if (op=='all') return AllCondition(((json['conditions'] as List?)??const[]).map((e)=>load(Map<String,dynamic>.from(e as Map))).toList());
    if (op=='any') return AnyCondition(((json['conditions'] as List?)??const[]).map((e)=>load(Map<String,dynamic>.from(e as Map))).toList());
    if (op=='not') return NotCondition(load(Map<String,dynamic>.from(json['condition'] as Map)));
    return EventCondition(eventType:json['type'] as String, path:json['path'] as String?, equals:json['equals'], contains:json['contains'], greaterThan:json['greaterThan'] as num?, lessThan:json['lessThan'] as num?, eventVersion:(json['version'] as num?)?.toInt());
  }
}
