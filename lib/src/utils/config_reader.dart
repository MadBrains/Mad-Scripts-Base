import 'dart:convert';
import 'dart:io';

import 'package:mad_scripts_base/src/src.dart';

/// The `ConfigReader` class is designed to read and transform configuration files.
///
/// It provides a static method `fromFile`, which loads a configuration file,
/// converts it into an object of the specified type, and returns it.
class ConfigReader {
  /// Reads a configuration file and transforms it into an object of the specified type.
  ///
  /// Parameters:
  /// - `path` (`String`): The path to the configuration file.
  /// - `transformer` (`required T Function(Map<String, dynamic>)`): A function that takes
  ///   the configuration data as a map and returns an object of type `T`.
  ///
  /// Returns:
  /// - `T`: An instance of type `T` created from the configuration data.
  ///
  /// Throws:
  /// - `ScriptException`: If reading or transforming the configuration fails.
  static T fromFile<T>(
      String path, {
        required T Function(Map<String, dynamic>) transformer,
      }) {
    try {
      final String configContent = File(path).readAsStringSync();
      output.debug(configContent, blockTitle: 'Read Config');
      final T result = transformer(jsonDecode(configContent) as Map<String, dynamic>);

      return result;
    } catch (e) {
      throw ScriptException(e.toString().red);
    }
  }
}
