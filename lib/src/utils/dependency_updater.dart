// ignore_for_file: always_specify_types

import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';
import 'package:mad_scripts_base/src/src.dart';

/// Represents a Flutter/Dart project dependency that can be defined
/// using a version string, a Git configuration, or a local path.
/// This class provides convenient methods for creating and managing
/// dependencies for insertion or updates in `pubspec.yaml`.
///
/// Usage examples:
///
/// ```dart
/// // Standard dependency with a version
/// Dependency(name: 'http', version: '^0.13.0');
///
/// // Dependency from Git
/// Dependency.git(
///   name: 'mad_inspector_debug_menu',
///   url: 'ssh://git@git.mb-dev.ru:10022/madbrains/internal/mad-inspector-flutter.git',
///   ref: '3.2.1',
///   path: 'packages/mad_inspector_debug_menu',
/// );
///
/// // Dependency from a local path
/// Dependency.path(name: 'local_package', path: '../local_package');
/// ```
class Dependency {
  /// Creates a standard dependency with a specified version.
  ///
  /// [name] — the name of the dependency.
  /// [version] — the version string (e.g., `^1.0.0`).
  const Dependency({required this.name, required this.version});

  /// Factory constructor for creating a dependency based on a Git repository.
  ///
  /// Allows specifying a dependency hosted in a Git repository.
  ///
  /// [name] — the name of the dependency.
  /// [url] — the Git repository URL.
  /// [ref] (optional) — branch, tag, or commit to use.
  /// [path] (optional) — subdirectory within the repository.
  ///
  /// Returns a [Dependency] configured to use a Git source.
  ///
  /// Example:
  /// ```dart
  /// Dependency.git(
  ///   name: 'my_package',
  ///   url: 'https://github.com/user/repo.git',
  ///   ref: 'main',
  ///   path: 'subdir',
  /// );
  /// ```
  factory Dependency.git({
    required String name,
    required String url,
    String? ref,
    String? path,
  }) {
    // Construct the Git dependency structure with optional ref and path.
    final Map<String, dynamic> git = <String, dynamic>{'url': url};
    if (ref != null) {
      git['ref'] = ref;
    }
    if (path != null) {
      git['path'] = path;
    }

    // Return Dependency with nested Git structure.
    return Dependency(name: name, version: <String, Map<String, dynamic>>{'git': git});
  }

  /// Factory constructor for creating a dependency based on a local path.
  ///
  /// Used when the dependency refers to a local package by file path.
  ///
  /// [name] — the name of the dependency.
  /// [path] — the path to the local package.
  ///
  /// Returns a [Dependency] configured for path usage.
  ///
  /// Example:
  /// ```dart
  /// Dependency.path(name: 'local_package', path: '../local_package');
  /// ```
  factory Dependency.path({
    required String name,
    required String path,
  }) {
    return Dependency(name: name, version: <String, String>{'path': path});
  }

  /// The name of the dependency.
  final String name;

  /// The version or configuration of the dependency.
  ///
  /// Can be a version string (e.g., `^1.0.0`) or a nested configuration
  /// for Git or path-based dependencies.
  final Object version;

  /// Converts the dependency to a map format suitable for insertion into `pubspec.yaml`.
  ///
  /// Returns a [Map] representation with the dependency name as the key and
  /// its version/configuration as the value.
  ///
  /// Example output for a Git dependency:
  /// ```dart
  /// {
  ///   'my_package': {
  ///     'git': {
  ///       'url': 'https://github.com/user/repo.git',
  ///       'ref': 'main',
  ///       'path': 'subdir',
  ///     }
  ///   }
  /// }
  /// ```
  Map<String, Object> toMap() => <String, Object>{name: version};
}

/// The [DependencyUpdater] class is used to update dependencies in a `pubspec.yaml` file.
class DependencyUpdater {
  static const String _dependencies = 'dependencies';

  /// Updates the [dependencies] section in the specified [pubspecPath].
  ///
  /// - [dependencies]: The list of dependencies to add or update.
  /// - [pubspecPath]: The path to the `pubspec.yaml` file.
  static Future<void> update({
    required List<Dependency> dependencies,
    String pubspecPath = 'pubspec.yaml',
  }) async {
    if (dependencies.isEmpty) return;

    // Verify that pubspec.yaml exists
    final File file = File(pubspecPath);
    if (!file.existsSync()) {
      return output.error('File not found: $pubspecPath');
    }

    // Read the content of pubspec.yaml
    final String yamlText = file.readAsStringSync();
    final YamlEditor yamlEditor = YamlEditor(yamlText);
    final YamlMap yamlMap = (loadYaml(yamlText) as Map)[_dependencies] as YamlMap;

    // Insert or update dependencies in the 'dependencies' section
    for (final Dependency dependency in dependencies) {
      yamlEditor.update(
        <String>[_dependencies, dependency.name],
        dependency.version,
      );

      if (yamlMap.containsKey(dependency.name)) {
        output.info('Dependency ${dependency.name} updated');
      } else {
        output.info('Dependency ${dependency.name} added to $pubspecPath');
      }
    }

    file.writeAsStringSync(yamlEditor.toString());
  }
}
