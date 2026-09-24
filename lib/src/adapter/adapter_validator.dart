import '../catalog.dart';
import '../event.dart';

class AdapterValidationIssue {
  const AdapterValidationIssue(this.level, this.message);
  final String level;
  final String message;
}

/// Validates events emitted by an adapter against the event catalog.
class AdapterValidator {
  const AdapterValidator(this.catalog);
  final EventCatalog catalog;

  List<AdapterValidationIssue> validate(GameEvent event) {
    if (!catalog.hasEvent(event.type, event.version)) {
      return [AdapterValidationIssue('error',
          'Unknown event contract: ${event.type} v${event.version}')];
    }
    return const [];
  }
}
