// Validates game content (master spec §16/§19/§11.3) against specs/schemas/*.schema.json.
// Usage: dart run bin/validate_content.dart <content_dir> [schema_dir=specs/schemas]
// Content file selects its schema via a "$schema": "<kind>" field (quest|dialogue|item|encounter|location).
// Exit 1 on validation errors, 64 on bad usage. Hand-rolled JSON-Schema subset validator:
// supports type/required/properties/pattern/enum/items/minItems/maxItems/minimum/maximum/maxLength.
import 'dart:convert';
import 'dart:io';

const maxContentDepth = 4; // master spec HB-01 content limit

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('usage: dart run bin/validate_content.dart <content_dir> [schema_dir]');
    exitCode = 64;
    return;
  }
  final errors = validateDirectory(args[0], args.length > 1 ? args[1] : 'specs/schemas', stdout.writeln);
  if (errors > 0) exitCode = 1;
}

/// Validates every .json file in [contentPath], choosing the schema by the
/// file's "$schema": "<kind>" field. Returns the number of errors; lines via [out].
int validateDirectory(String contentPath, String schemaPath, void Function(String) out) {
  final contentDir = Directory(contentPath);
  final schemaDir = Directory(schemaPath);
  if (!contentDir.existsSync() || !schemaDir.existsSync()) {
    out('error: directory not found');
    return 1;
  }
  final schemas = <String, Map<String, dynamic>>{};
  for (final f in schemaDir.listSync()) {
    if (f is File && f.path.endsWith('.schema.json')) {
      final name = f.uri.pathSegments.last.replaceAll('.schema.json', '');
      schemas[name] = Map<String, dynamic>.from(jsonDecode(f.readAsStringSync()) as Map);
    }
  }
  var errors = 0;
  var checked = 0;
  for (final entity in contentDir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.json')) continue;
    checked++;
    try {
      final doc = Map<String, dynamic>.from(jsonDecode(entity.readAsStringSync()) as Map);
      final kind = doc[r'$schema'] as String?;
      if (kind == null || !schemas.containsKey(kind)) {
        errors++;
        out('${entity.path}: ERROR unknown or missing \$schema kind "$kind" (known: ${schemas.keys.join(', ')})');
        continue;
      }
      final depth = _depth(doc) - 1; // root object itself is not nesting
      if (depth > maxContentDepth) {
        errors++;
        out('${entity.path}: ERROR nesting depth $depth > $maxContentDepth (HB-01 content limit)');
      }
      for (final e in _validate(doc, schemas[kind]!, r'$')) {
        errors++;
        out('${entity.path}: ERROR $e');
      }
    } catch (e) {
      errors++;
      out('${entity.path}: ERROR invalid json: $e');
    }
  }
  out('Content validation complete: $checked file(s), $errors error(s).');
  return errors;
}

int _depth(Object? v) {
  if (v is Map) return 1 + (v.values.isEmpty ? 0 : v.values.map(_depth).reduce((a, b) => a > b ? a : b));
  if (v is List) return 1 + (v.isEmpty ? 0 : v.map(_depth).reduce((a, b) => a > b ? a : b));
  return 0;
}

List<String> _validate(Object? value, Map<String, dynamic> schema, String path) {
  final out = <String>[];
  final type = schema['type'] as String?;
  if (type != null && !_typeOk(value, type)) {
    out.add('$path: expected $type, got ${_typeName(value)}');
    return out;
  }
  if (schema.containsKey('enum')) {
    final allowed = (schema['enum'] as List).map((e) => '$e').toSet();
    if (!allowed.contains('$value')) out.add('$path: "$value" not in enum ${allowed.toList()..sort()}');
  }
  if (value is String) {
    final pattern = schema['pattern'] as String?;
    if (pattern != null && !RegExp(pattern).hasMatch(value)) out.add('$path: "$value" fails pattern $pattern');
    final maxLength = schema['maxLength'] as int?;
    if (maxLength != null && value.length > maxLength) out.add('$path: length ${value.length} > maxLength $maxLength');
  }
  if (value is num) {
    final min = schema['minimum'] as num?;
    if (min != null && value < min) out.add('$path: $value < minimum $min');
    final max = schema['maximum'] as num?;
    if (max != null && value > max) out.add('$path: $value > maximum $max');
  }
  if (value is List) {
    final minItems = schema['minItems'] as int?;
    if (minItems != null && value.length < minItems) out.add('$path: ${value.length} items < minItems $minItems');
    final maxItems = schema['maxItems'] as int?;
    if (maxItems != null && value.length > maxItems) out.add('$path: ${value.length} items > maxItems $maxItems');
    final items = schema['items'];
    if (items is Map<String, dynamic>) {
      for (var i = 0; i < value.length; i++) {
        out.addAll(_validate(value[i], items, '$path[$i]'));
      }
    }
  }
  if (value is Map) {
    for (final req in (schema['required'] as List? ?? const [])) {
      if (!value.containsKey(req)) out.add('$path: missing required field "$req"');
    }
    final props = schema['properties'] as Map<String, dynamic>? ?? const {};
    for (final entry in value.entries) {
      final prop = props[entry.key];
      if (prop is Map<String, dynamic>) {
        out.addAll(_validate(entry.value, prop, '$path.${entry.key}'));
      }
    }
  }
  return out;
}

bool _typeOk(Object? v, String t) => switch (t) {
      'object' => v is Map,
      'array' => v is List,
      'string' => v is String,
      'integer' => v is int,
      'number' => v is num,
      'boolean' => v is bool,
      _ => true,
    };

String _typeName(Object? v) => switch (v) {
      null => 'null',
      Map _ => 'object',
      List _ => 'array',
      String _ => 'string',
      int _ => 'integer',
      num _ => 'number',
      bool _ => 'boolean',
      _ => 'unknown',
    };
