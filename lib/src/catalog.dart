import 'condition.dart';

class EventCatalogEntry {
  const EventCatalogEntry({required this.type, required this.version, required this.producer, this.payload = const {}});
  final String type;
  final int version;
  final String producer;
  final Map<String,Object?> payload;
}
class EffectCatalogEntry {
  const EffectCatalogEntry({required this.type, this.payload = const {}});
  final String type;
  final Map<String,Object?> payload;
}
class EventCatalog {
  const EventCatalog({required this.schemaVersion, this.events = const [], this.effects = const []});
  final int schemaVersion;
  final List<EventCatalogEntry> events;
  final List<EffectCatalogEntry> effects;
  bool hasEvent(String type, [int? version]) => events.any((e)=>e.type==type && (version==null || e.version==version));
  bool hasEffect(String type) => effects.any((e)=>e.type==type);
}
class EventCatalogLoader {
  EventCatalog load(Map<String,dynamic> json) => EventCatalog(schemaVersion:(json['schemaVersion'] as num?)?.toInt()??1,
    events:((json['events'] as List?)??const[]).map((e){final m=Map<String,dynamic>.from(e as Map);return EventCatalogEntry(type:m['type'] as String,version:(m['version'] as num?)?.toInt()??1,producer:m['producer'] as String? ?? '',payload:Map<String,Object?>.from(m['payload'] as Map? ?? const {}));}).toList(),
    effects:((json['effects'] as List?)??const[]).map((e){final m=Map<String,dynamic>.from(e as Map);return EffectCatalogEntry(type:m['type'] as String,payload:Map<String,Object?>.from(m['payload'] as Map? ?? const {}));}).toList());
}
