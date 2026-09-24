import 'dart:io';

/// Syncs engine content from this repo (source of truth) into the host.
///
/// Targets:
/// 1. Vendored package: <wanderers>/packages/void_event_engine (engine source of truth for integration).
/// 2. Bundled story assets: <wanderers>/assets/story_units (Flutter asset folders are not recursive).
///
/// Usage: dart run bin/sync_to_wanderers.dart [wanderersRoot=C:\dev\Wanderers]
const _packageDirs = ['lib', 'bin', 'test', 'schema', 'fixtures', 'stories', 'examples', 'docs'];
const _packageFiles = [
  'pubspec.yaml',
  'README.md',
  'AGENTS.md',
  'events.catalog.json',
  'effects.catalog.json',
  'vocabulary.catalog.json',
  'convoy_escort.json',
];
const _assetSourceDirs = ['stories/act_01'];

void main(List<String> args) {
  final wanderers = Directory(args.isEmpty ? r'C:\dev\Wanderers' : args[0]);
  if (!wanderers.existsSync()) {
    stderr.writeln('Wanderers root not found: ${wanderers.path}');
    exitCode = 64;
    return;
  }
  final root = Directory.current.path;
  var copied = 0;

  void copyInto(Directory source, Directory target) {
    if (!target.existsSync()) target.createSync(recursive: true);
    for (final entity in source.listSync()) {
      final targetPath = '${target.path}${Platform.pathSeparator}${_name(entity.path)}';
      if (entity is Directory) {
        copyInto(entity, Directory(targetPath));
      } else if (entity is File) {
        entity.copySync(targetPath);
        copied++;
      }
    }
  }

  // 1. Vendored package: clean replace of synced directories.
  final vendored = Directory('${wanderers.path}/packages/void_event_engine');
  if (!vendored.existsSync()) {
    stderr.writeln('Vendored package missing: ${vendored.path}');
    exitCode = 1;
    return;
  }
  for (final dir in _packageDirs) {
    final source = Directory('$root/$dir');
    final target = Directory('${vendored.path}/$dir');
    if (target.existsSync()) target.deleteSync(recursive: true);
    if (source.existsSync()) copyInto(source, target);
  }
  for (final file in _packageFiles) {
    final source = File('$root/$file');
    if (source.existsSync()) source.copySync('${vendored.path}/$file');
  }

  // 2. Bundled story assets: clean replace, files copied flat per directory.
  final assetsDir = Directory('${wanderers.path}/assets/story_units');
  if (assetsDir.existsSync()) assetsDir.deleteSync(recursive: true);
  for (final sourceDir in _assetSourceDirs) {
    final source = Directory('$root/$sourceDir');
    if (!source.existsSync()) continue;
    for (final entity in source.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.json')) continue;
      final relative = entity.path.substring(source.path.length + 1);
      final target = File('${assetsDir.path}/act_01/${relative.replaceAll('\\', '/')}');
      target.parent.createSync(recursive: true);
      entity.copySync(target.path);
      copied++;
    }
  }

  stdout.writeln('Sync complete: $copied file(s) -> ${vendored.path} and ${assetsDir.path}');
}

String _name(String path) => path.split(Platform.pathSeparator).last;
