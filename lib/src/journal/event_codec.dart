import 'dart:convert';

import '../event.dart';

/// Stable JSON codec for journal records. The codec is intentionally separate
/// from gameplay so persistence format changes can be migrated explicitly.
class EventJsonCodec {
  const EventJsonCodec();

  Map<String, Object?> encode(GameEvent event) => {
        'id': event.id,
        'type': event.type,
        'version': event.version,
        'payload': event.payload,
        'tags': event.tags,
        'source': event.source,
        'entityId': event.entityId,
        'correlationId': event.correlationId,
        'causationId': event.causationId,
        'sequence': event.sequence,
        'occurredAt': event.occurredAt?.toIso8601String(),
      };

  String encodeLine(GameEvent event) => jsonEncode(encode(event));

  GameEvent decode(Map<String, dynamic> json) => GameEvent(
        id: json['id'] as String,
        type: json['type'] as String,
        version: (json['version'] as num?)?.toInt() ?? 1,
        payload: Map<String, Object?>.from(json['payload'] as Map? ?? const {}),
        tags: (json['tags'] as List? ?? const []).map((e) => e.toString()).toList(),
        source: json['source'] as String? ?? '',
        entityId: json['entityId'] as String?,
        correlationId: json['correlationId'] as String?,
        causationId: json['causationId'] as String?,
        sequence: (json['sequence'] as num?)?.toInt(),
        occurredAt: json['occurredAt'] == null ? null : DateTime.parse(json['occurredAt'] as String),
      );

  GameEvent decodeLine(String line) => decode(jsonDecode(line) as Map<String, dynamic>);
}
