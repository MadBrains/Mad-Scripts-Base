import 'package:mad_scripts_base/src/utils/extensions_generic.dart';

/// Extension for the `String` class that adds helper methods for working with string formats.
extension StringExt on String {
  /// Checks whether the string is in UpperCamelCase (PascalCase).
  bool get isUpperCamelCase => RegExp(r'^[A-Za-z]+(?:[A-Z][a-z]*)*$').hasMatch(this);

  /// Checks whether the string is in lowerCamelCase.
  bool get isLowerCamelCase => RegExp(r'^[a-z]+(?:[A-Z][a-z]*)*$').hasMatch(this);

  /// Checks whether the string is in snake_case.
  bool get isSnakeCase {
    final RegExp snakeCaseRegex = RegExp(r'^[a-z][a-z0-9]*(?:_[a-z0-9]+)*$');
    return snakeCaseRegex.hasMatch(this);
  }

  /// Converts the string to snake_case.
  String get toSnakeCase => _wordList.map((String word) => word.toLowerCase()).join('_');

  /// Converts the string to kebab-case.
  String get toKebabCase => _wordList.map((String word) => word.toLowerCase()).join('-');

  /// Converts the string to UpperCamelCase (PascalCase).
  String get toUpperCamelCase {
    final List<String> words = _wordList;
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
      }
    }
    return words.join();
  }

  /// Converts the string to lowerCamelCase.
  String get toCamelCase {
    final String upperCamelCase = toUpperCamelCase;
    return upperCamelCase[0].toLowerCase() + upperCamelCase.substring(1);
  }

  /// Splits the string into words based on underscores, hyphens, or case changes.
  List<String> get _wordList => split(RegExp(r'[_\-]|(?<=[a-z])(?=[A-Z])'));

  /// Colors the string green for console output.
  String get green => '\x1B[32m$this\x1B[0m';

  /// Colors the string red for console output.
  String get red => '\x1B[31m$this\x1B[0m';

  /// Colors the string yellow for console output.
  String get yellow => '\x1B[33m$this\x1B[0m';

  /// Colors the string blue for console output.
  String get blue => '\x1B[34m$this\x1B[0m';
}

/// Extension for the `bool` class that adds text representation methods based on the value.
extension BoolExt on bool {
  /// Returns "Enable" in green if `true`, and "Disable" in red if `false`.
  String get enableModeText => this ? 'Enable'.green : 'Disable'.red;
}

/// Extension for `List<Enum>` that adds helper methods for working with enums.
extension EnumX<T extends Enum> on List<T> {
  /// Finds an enum value by its [name].
  ///
  /// If not found, returns [defaultValue] if provided, otherwise throws an error.
  T fromName(String name, {T? defaultValue}) {
    return fromTest(
          (T element) => element.name == name,
      defaultValue: defaultValue,
    );
  }

  /// Finds an enum value that matches a given [test].
  ///
  /// If not found, returns [defaultValue] if provided, otherwise throws an error.
  T fromTest(bool Function(T) test, {T? defaultValue}) {
    return firstWhere(
      test,
      orElse: defaultValue != null ? () => defaultValue : null,
    );
  }

  /// Finds an enum value that matches a given [test], or returns `null` if not found.
  T? fromTestOrNull(bool Function(T) test) {
    return firstWhereOrNull(test);
  }
}
