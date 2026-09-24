import 'dart:convert';
import 'dart:io';
import 'package:void_event_engine/void_event_engine.dart';
void main(List<String> args) {
  final root=Directory(args.isEmpty?'examples':args[0]); final catalogFile=File(args.length>1?args[1]:'events.catalog.json');
  final catalog=EventCatalogLoader().load(Map<String,dynamic>.from(jsonDecode(catalogFile.readAsStringSync()) as Map));
  final loader=MissionJsonLoader(); final validator=MissionValidator(catalog:catalog); var errors=0; var warnings=0;
  for(final entity in root.listSync(recursive:true)) { if(entity is! File||!entity.path.endsWith('.json')) continue; try { final mission=loader.load(Map<String,dynamic>.from(jsonDecode(entity.readAsStringSync()) as Map)); for(final i in validator.validate(mission)){ stdout.writeln('${entity.path}:${i.toString()}'); if(i.error) errors++; else warnings++; } } catch(e){ errors++; stdout.writeln('${entity.path}: ERROR invalid content: $e'); } }
  stdout.writeln('Validation complete: $errors error(s), $warnings warning(s).'); if(errors>0) exitCode=1;
}
