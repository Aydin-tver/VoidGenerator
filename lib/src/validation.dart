import 'catalog.dart';
import 'condition.dart';
import 'mission_definition.dart';

class ValidationIssue { const ValidationIssue(this.path,this.message,{this.error=true}); final String path; final String message; final bool error; @override String toString()=> '${error?'ERROR':'WARN'} $path: $message'; }
class MissionValidator {
  const MissionValidator({this.catalog});
  final EventCatalog? catalog;
  List<ValidationIssue> validate(MissionDefinition m) {
    final issues=<ValidationIssue>[]; final ids=<String>{}; final stepMap={for(final s in m.steps)s.id:s}; final outcomeIds=<String>{for(final o in m.outcomes)o.id};
    if(!RegExp(r'^mission\\.[a-z0-9_.-]+$').hasMatch(m.id)) issues.add(const ValidationIssue('id','must match mission.<lowercase-id>'));
    if(m.version<1) issues.add(const ValidationIssue('version','must be >= 1'));
    if(m.steps.isEmpty) issues.add(const ValidationIssue('steps','must contain at least one step'));
    if(m.startStepId!=null && !stepMap.containsKey(m.startStepId)) issues.add(ValidationIssue('startStepId','unknown step ${m.startStepId}'));
    for(final s in m.steps){
      if(!ids.add(s.id)) issues.add(ValidationIssue('steps.${s.id}','duplicate step id'));
      if(s.count<1) issues.add(ValidationIssue('steps.${s.id}.count','must be >= 1'));
      if(s.displayKey.isEmpty) issues.add(ValidationIssue('steps.${s.id}.displayKey','required'));
      if(s.locationKey.isEmpty && s.clueKey.isEmpty) issues.add(ValidationIssue('steps.${s.id}','requires locationKey or clueKey'));
      if(s.timeoutSeconds!=null && s.timeoutSeconds!<1) issues.add(ValidationIssue('steps.${s.id}.timeoutSeconds','must be >= 1'));
      if(s.nextStepId!=null && !stepMap.containsKey(s.nextStepId)) issues.add(ValidationIssue('steps.${s.id}.nextStepId','unknown step ${s.nextStepId}'));
      if(s.outcomeId!=null && !outcomeIds.contains(s.outcomeId)) issues.add(ValidationIssue('steps.${s.id}.outcomeId','unknown outcome ${s.outcomeId}'));
      if(s.failOutcomeId!=null && !outcomeIds.contains(s.failOutcomeId)) issues.add(ValidationIssue('steps.${s.id}.failOutcomeId','unknown outcome ${s.failOutcomeId}'));
      _validateCondition(s.eventCondition,'steps.${s.id}.event',issues);
    }
    for(final o in m.outcomes){ if(o.nextStepId!=null&&!stepMap.containsKey(o.nextStepId)) issues.add(ValidationIssue('outcomes.${o.id}.nextStepId','unknown step ${o.nextStepId}')); }
    if(catalog!=null){ for(final s in m.steps) _validateCatalog(s.eventCondition,'steps.${s.id}.event',issues); for(final o in m.outcomes) for(final e in o.effects) if(!catalog!.hasEffect(e.type)) issues.add(ValidationIssue('outcomes.${o.id}.effects','unknown effect type ${e.type}')); }
    _validateGraph(m,stepMap,issues);
    return issues;
  }
  void _validateCondition(Condition c,String path,List<ValidationIssue> out){
    if(c is EventCondition){ if(c.eventType.isEmpty) out.add(ValidationIssue(path+'.type','required')); if(c.greaterThan!=null&&c.lessThan!=null&&c.greaterThan!>=c.lessThan!) out.add(ValidationIssue(path,'greaterThan must be less than lessThan')); }
    if(c is AllCondition && c.children.isEmpty) out.add(ValidationIssue(path,'all requires at least one condition'));
    if(c is AnyCondition && c.children.isEmpty) out.add(ValidationIssue(path,'any requires at least one condition'));
    if(c is NotCondition) _validateCondition(c.child,path+'.condition',out);
    if(c is AllCondition) for(var i=0;i<c.children.length;i++) _validateCondition(c.children[i],'$path.conditions[$i]',out);
    if(c is AnyCondition) for(var i=0;i<c.children.length;i++) _validateCondition(c.children[i],'$path.conditions[$i]',out);
  }
  void _validateCatalog(Condition c,String path,List<ValidationIssue> out){
    if(c is EventCondition){ if(!catalog!.hasEvent(c.eventType,c.eventVersion)) out.add(ValidationIssue(path,'event type/version is not in catalog: ${c.eventType}@${c.eventVersion??'*'}')); }
    if(c is AllCondition) for(final x in c.children) _validateCatalog(x,path,out);
    if(c is AnyCondition) for(final x in c.children) _validateCatalog(x,path,out);
    if(c is NotCondition) _validateCatalog(c.child,path,out);
  }
  void _validateGraph(MissionDefinition m,Map<String,MissionStepDefinition> map,List<ValidationIssue> out){
    final starts=m.startStepId!=null?[m.startStepId!]:map.keys.where((id)=>!map.values.any((s)=>s.nextStepId==id)).toList();
    if(starts.isEmpty && map.isNotEmpty) out.add(const ValidationIssue('steps','no reachable start step; graph is cyclic'));
    final seen=<String>{}; final stack=[...starts]; while(stack.isNotEmpty){ final id=stack.removeLast(); if(!seen.add(id)) continue; final s=map[id]; if(s?.nextStepId!=null) stack.add(s!.nextStepId!); }
    for(final id in map.keys.where((id)=>!seen.contains(id))) out.add(ValidationIssue('steps.$id','unreachable step from start',error:false));
    for(final id in map.keys){ final path=<String>{}; var cur=id; while(map[cur]?.nextStepId!=null){ if(!path.add(cur)){out.add(ValidationIssue('steps.$id','cycle detected through $cur'));break;} cur=map[cur]!.nextStepId!; if(path.length>map.length)break; } }
  }
}
