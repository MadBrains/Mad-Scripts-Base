/// A utility class containing helper methods for working with the file system and boolean values.
abstract class Helper {
  /// Converts a string to a boolean value.
  ///
  /// Returns `true` for the string `'true'`, `false` for `'false'`,
  /// and `null` for any other value.
  ///
  /// Parameters:
  /// - [value]: The string to convert to a boolean.
  ///
  /// Example:
  /// ```dart
  /// bool? isTrue = Helper.parseBool('true'); // Returns true
  /// ```
  static bool? parseBool(String? value) {
    return switch (value) { 'true' => true, 'false' => false, _ => null };
  }

  /// Returns a logical condition based on the [force] flag.
  ///
  /// If [force] is not `null`, its value is returned.
  /// Otherwise, returns the value of [value].
  ///
  /// Parameters:
  /// - [force]: Optional boolean value used as an override.
  /// - [value]: Default boolean value if [force] is not provided.
  ///
  /// Example:
  /// ```dart
  /// bool condition = Helper.forceCondition(null, true); // Returns true
  /// ```
  static bool forceCondition(bool? force, bool value) {
    if (force != null) {
      return force;
    } else {
      return value;
    }
  }
}
