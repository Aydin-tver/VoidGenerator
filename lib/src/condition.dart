import 'event.dart';

abstract interface class Condition {
  bool matches(GameEvent event, EvaluationContext context);
}

class EvaluationContext {
  const EvaluationContext({this.flags = const {}, this.values = const {}, this.eventVersion = 1});
  final Map<String, bool> flags;
  final Map<String, num> values;
  final int eventVersion;
  bool flag(String id) => flags[id] ?? false;
  num value(String id) => values[id] ?? 0;
}

class EventCondition implements Condition {
  const EventCondition({required this.eventType, this.path, this.equals, this.contains, this.greaterThan, this.lessThan, this.eventVersion});
  final String eventType;
  final String? path;
  final Object? equals;
  final Object? contains;
  final num? greaterThan;
  final num? lessThan;
  final int? eventVersion;

  @override
  bool matches(GameEvent event, EvaluationContext context) {
    if (event.type != eventType) return false;
    if (eventVersion != null && event.version != eventVersion) return false;
    if (path == null) return true;
    final value = readPath(event.payload, path!);
    if (equals != null && value != equals) return false;
    if (contains != null && value is! List && value is! String) return false;
    if (contains != null && value is List && !value.contains(contains)) return false;
    if (contains != null && value is String && !value.contains('$contains')) return false;
    if (greaterThan != null && (value is! num || value <= greaterThan!)) return false;
    if (lessThan != null && (value is! num || value >= lessThan!)) return false;
    return true;
  }

  static Object? readPath(Map<String, Object?> map, String path) {
    Object? current = map;
    for (final part in path.split('.')) {
      if (current is Map) current = current[part]; else return null;
    }
    return current;
  }
}

class AllCondition implements Condition {
  const AllCondition(this.children);
  final List<Condition> children;
  @override bool matches(GameEvent event, EvaluationContext context) => children.every((c) => c.matches(event, context));
}
class AnyCondition implements Condition {
  const AnyCondition(this.children);
  final List<Condition> children;
  @override bool matches(GameEvent event, EvaluationContext context) => children.any((c) => c.matches(event, context));
}
class NotCondition implements Condition {
  const NotCondition(this.child);
  final Condition child;
  @override bool matches(GameEvent event, EvaluationContext context) => !child.matches(event, context);
}

/// Collects statically known event types for bus subscription.
/// Composites contribute their children; NotCondition contributes nothing.
Set<String> conditionEventTypes(Condition condition) {
  final types = <String>{};
  _collectEventTypes(condition, types);
  return types;
}

void _collectEventTypes(Condition condition, Set<String> types) {
  if (condition is EventCondition) {
    types.add(condition.eventType);
  } else if (condition is AllCondition || condition is AnyCondition) {
    final children = condition is AllCondition
        ? condition.children
        : (condition as AnyCondition).children;
    for (final child in children) {
      _collectEventTypes(child, types);
    }
  }
}
