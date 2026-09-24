import 'event.dart';
import 'event_bus.dart';
import 'mission_definition.dart';
import 'mission_runtime.dart';

class MissionReplayResult { const MissionReplayResult({required this.completed,required this.failed,required this.progress,required this.lastSequence,required this.consumedEventIds}); final bool completed; final bool failed; final Map<String,int> progress; final int? lastSequence; final List<String> consumedEventIds; }
class MissionSimulator {
  const MissionSimulator();
  MissionReplayResult replay(MissionDefinition definition, Iterable<GameEvent> events, {DateTime? startAt}) {
    final ordered=events.toList(); final bus=EventBus(); final runtime=MissionRuntime(definition,bus); final start=startAt??(ordered.isEmpty?DateTime.utc(2000):ordered.first.occurredAt??DateTime.utc(2000));
    runtime.start(now:start); runtime.attach();
    for(final event in ordered){ final when=event.occurredAt??start; runtime.tick(when); if(runtime.completed||runtime.failed)break; bus.publish(event); if(runtime.completed||runtime.failed)break; }
    runtime.detach(); return MissionReplayResult(completed:runtime.completed,failed:runtime.failed,progress:Map.unmodifiable(runtime.progress),lastSequence:runtime.lastSequence,consumedEventIds:runtime.consumedEventIds.toList());
  }
}
