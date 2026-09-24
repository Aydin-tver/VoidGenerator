import '../catalog.dart';
import '../event.dart';

class EventContractIssue {
  const EventContractIssue(this.path, this.message);
  final String path;
  final String message;
  @override String toString() => '$path: $message';
}

/// Validates a concrete GameEvent against the semantic catalog payload shape.
class EventContractValidator {
  const EventContractValidator(this.catalog);
  final EventCatalog catalog;

  List<EventContractIssue> validate(GameEvent event) {
    EventCatalogEntry? entry;
    for (final candidate in catalog.events) {
      if (candidate.type == event.type && candidate.version == event.version) { entry = candidate; break; }
    }
    if (entry == null) return [EventContractIssue('type', 'unknown event contract ${event.type}@${event.version}')];
    final issues = <EventContractIssue>[];
    for (final spec in entry.payload.entries) {
      final nullable = spec.value.toString().endsWith('|null') || spec.value.toString().contains('|null');
      final value = event.payload[spec.key];
      if (value == null && nullable) continue;
      if (value == null) {
        issues.add(EventContractIssue('payload.${spec.key}', 'required'));
        continue;
      }
      final descriptor = spec.value.toString();
      final expected = descriptor.split('|').first;
      if (!_matches(value, descriptor)) issues.add(EventContractIssue('payload.${spec.key}', 'expected $descriptor, got ${value.runtimeType}'));
    }
    return issues;
  }

  bool _matches(Object value, String descriptor) {
    final parts = descriptor.split('|');
    final expected = parts.first;
    switch (expected) {
      case 'string': return value is String;
      case 'number': return value is num;
      case 'boolean': return value is bool;
      case 'object': return value is Map;
      case 'array': return value is List;
      default:
        if (value is! String) return false;
        return parts.contains(value);
    }
  }
}
