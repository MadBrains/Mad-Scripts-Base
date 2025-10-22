// ignore_for_file: type_literal_in_constant_pattern

import 'package:mad_scripts_base/src/script_templates/mtl/src/src.dart';

extension TagExtensions on String {
  /// Parses and replaces tags in the string.
  ///
  /// [replace] - a function that takes a tag and returns the replacement string.
  ///
  /// Returns a new string with tags replaced.
  String parseTags<T extends Tag>(String Function(T) replace) {
    final RegExp pattern = _getPattern<T>();

    return replaceAllMapped(pattern, (Match match) {
      final T tag = _createTag<T>(match) as T;

      return replace(tag);
    });
  }

  /// Finds all tags of a specific type in the string.
  ///
  /// Returns a list of the found tags.
  List<T> findAllTags<T extends Tag>() {
    final RegExp pattern = _getPattern<T>();
    final List<Match> matches = pattern.allMatches(this).toList(growable: false);
    final List<T> tags = <T>[];
    for (final Match match in matches) {
      tags.add(_createTag<T>(match) as T);
    }

    return tags;
  }

  /// Finds tags of a specific type in the string that satisfy a given condition.
  ///
  /// [test] - a predicate that checks a tag and returns true if it matches the condition.
  ///
  /// Returns a list of tags that satisfy the condition.
  List<T> findTagsWhere<T extends Tag>(bool Function(T tag) test) {
    final RegExp pattern = _getPattern<T>();
    final List<Match> matches = pattern.allMatches(this).toList(growable: false);
    final List<T> tags = <T>[];
    for (final Match match in matches) {
      final T tag = _createTag<T>(match) as T;
      if (test(tag)) {
        tags.add(tag);
      }
    }

    return tags;
  }

  RegExp _getPattern<T extends Tag>() {
    return switch (T) {
      SelfClosingTag => SelfClosingTag.pattern,
      BlockTag => BlockTag.pattern,
      InsertionPartTag => InsertionPartTag.pattern,
      IfTag => IfTag.pattern,
      ExportPartTag => ExportPartTag.pattern,
      _ => BlockTag.pattern,
    };
  }

  Tag _createTag<T extends Tag>(Match match) {
    return switch (T) {
      SelfClosingTag => SelfClosingTag.fromMatch(match),
      BlockTag => BlockTag.fromMatch(match),
      InsertionPartTag => InsertionPartTag.fromMatch(match),
      IfTag => IfTag.fromMatch(match),
      ExportPartTag => ExportPartTag.fromMatch(match),
      _ => BlockTag.fromMatch(match),
    };
  }
}
