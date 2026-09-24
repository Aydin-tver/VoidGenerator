import '../event.dart';

abstract interface class EventSchemaMigration {
  String get eventType;
  int get fromVersion;
  int get toVersion;
  GameEvent migrate(GameEvent event);
}

class EventSchemaMigrator {
  EventSchemaMigrator({Iterable<EventSchemaMigration> migrations = const []}) {
    for (final migration in migrations) register(migration);
  }

  final Map<String, List<EventSchemaMigration>> _migrations = {};

  void register(EventSchemaMigration migration) {
    _migrations.putIfAbsent(migration.eventType, () => []).add(migration);
  }

  GameEvent migrate(GameEvent event, {required int targetVersion}) {
    var current = event;
    final migrations = [...?_migrations[current.type]]
      ..sort((a, b) => a.fromVersion.compareTo(b.fromVersion));
    while (current.version < targetVersion) {
      final migration = migrations.where((m) => m.fromVersion == current.version).firstOrNull;
      if (migration == null) {
        throw StateError('No event migration for ${current.type} v${current.version} -> v$targetVersion');
      }
      current = migration.migrate(current);
      if (current.version != migration.toVersion) {
        throw StateError('Migration produced unexpected version ${current.version}');
      }
    }
    if (current.version > targetVersion) {
      throw StateError('Event ${current.type} v${current.version} is newer than target v$targetVersion');
    }
    return current;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
