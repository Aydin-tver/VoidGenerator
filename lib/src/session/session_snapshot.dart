import 'dart:convert';

/// A versioned, host-neutral save boundary for all event-driven runtimes.
/// Components own their internal schema; the coordinator owns ordering.
class EngineSessionSnapshot {
  const EngineSessionSnapshot({
    required this.sessionId,
    required this.schemaVersion,
    required this.lastEventSequence,
    required this.components,
    this.savedAt,
    this.correlationId,
  });

  final String sessionId;
  final int schemaVersion;
  final int? lastEventSequence;
  final Map<String, Map<String, Object?>> components;
  final DateTime? savedAt;
  final String? correlationId;

  Map<String, Object?> toJson() => {
        'sessionId': sessionId,
        'schemaVersion': schemaVersion,
        'lastEventSequence': lastEventSequence,
        'components': components,
        if (savedAt != null) 'savedAt': savedAt!.toIso8601String(),
        if (correlationId != null) 'correlationId': correlationId,
      };

  String encode() => jsonEncode(toJson());

  factory EngineSessionSnapshot.fromJson(Map<String, dynamic> json) => EngineSessionSnapshot(
        sessionId: json['sessionId'] as String,
        schemaVersion: (json['schemaVersion'] as num).toInt(),
        lastEventSequence: (json['lastEventSequence'] as num?)?.toInt(),
        components: Map<String, Map<String, Object?>>.from(
          (json['components'] as Map? ?? const {}).map(
            (key, value) => MapEntry(key.toString(), Map<String, Object?>.from(value as Map)),
          ),
        ),
        savedAt: json['savedAt'] == null ? null : DateTime.parse(json['savedAt'] as String),
        correlationId: json['correlationId'] as String?,
      );

  factory EngineSessionSnapshot.decode(String encoded) =>
      EngineSessionSnapshot.fromJson(jsonDecode(encoded) as Map<String, dynamic>);
}

/// A stateful runtime that can participate in a unified save/restore boundary.
abstract interface class SessionSnapshotComponent {
  String get id;
  int get schemaVersion;
  Map<String, Object?> capture();
  void restore(Map<String, Object?> snapshot);
}

/// Adapter for an arbitrary runtime. This keeps the engine independent from
/// Wanderers-specific classes while allowing concrete integrations to expose
/// their native snapshots.
class CallbackSnapshotComponent implements SessionSnapshotComponent {
  CallbackSnapshotComponent({required this.id, this.schemaVersion = 1, required this._capture, required this._restore});

  @override
  final String id;
  @override
  final int schemaVersion;
  final Map<String, Object?> Function() _capture;
  final void Function(Map<String, Object?> snapshot) _restore;

  @override
  Map<String, Object?> capture() => Map<String, Object?>.from(_capture());

  @override
  void restore(Map<String, Object?> snapshot) => _restore(snapshot);
}
