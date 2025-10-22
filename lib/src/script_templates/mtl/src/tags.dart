import 'package:mad_scripts_base/src/script_templates/mtl/src/src.dart';

/// Base class for a tag; other tags inherit from it.
/// DO NOT USE directly — work only with [SelfClosingTag] and [BlockTag].
abstract class Tag {
  const Tag({
    required this.name,
    this.rawAttributes = '',
    required this.attributes,
  });

  /// Tag name.
  final String name;

  /// Raw attribute string as it appears in the template.
  final String rawAttributes;

  /// Parsed attributes map.
  final Map<String, String> attributes;

  /// Parses key-value attributes from a parameter string.
  static Map<String, String> _parseAttributes(String paramsString) {
    final Map<String, String> params = <String, String>{};
    final RegExp paramPattern = RegExp(r'(\w+)=(\w+(?:\.\w+)?|"[^"]*")');
    for (final RegExpMatch match in paramPattern.allMatches(paramsString)) {
      final String key = match.group(1) ?? '';
      String value = match.group(2) ?? '';
      if (value.startsWith('"') && value.endsWith('"')) {
        value = value.substring(1, value.length - 1);
      }
      params[key] = value;
    }

    return params;
  }

  /// Parses a full tag match returning:
  /// (tagName, rawAttributes, parsedAttributes, content)
  static (String, String, Map<String, String>, String) _parseMatchWithTag(
      Match match,
      ) {
    final String tag = match.group(1)?.trim() ?? '';
    final String params = match.group(2)?.trim() ?? '';
    final String content = match.groupCount > 2 ? match.group(3)?.trim() ?? '' : '';

    return (tag, params, _parseAttributes(params), content);
  }

  /// Parses a tag match that does not include the tag name in the groups,
  /// returning: (rawAttributes, parsedAttributes, content)
  static (String rawAttributes, Map<String, String> attributes, String content) _parseMatch(Match match) {
    final String params = match.group(1)?.trim() ?? '';
    final String content = match.groupCount > 1 ? match.group(2)?.trim() ?? '' : '';

    return (params, _parseAttributes(params), content);
  }
}

/// Base class for self-closing tags.
///
/// Example tag:
/// ```xml
/// {{insertion_part file=t.madt id=1}}
/// ```
class SelfClosingTag extends Tag {
  const SelfClosingTag({
    required super.name,
    required super.attributes,
    super.rawAttributes,
  });

  /// Creates a [SelfClosingTag] from a regex match.
  factory SelfClosingTag.fromMatch(Match match) {
    final (
    String tag,
    String rawAttributes,
    Map<String, String> attributes,
    _,
    ) = Tag._parseMatchWithTag(match);

    return SelfClosingTag(
      name: tag,
      attributes: attributes,
      rawAttributes: rawAttributes,
    );
  }

  /// Regex pattern for self-closing tags with any word-like name.
  static RegExp get pattern => TagPatterns.selfClosing(r'(\w+)');
}

/// Base class for block tags.
///
/// Example tag:
/// ```xml
/// {{export_part id=1}}
/// Some code
/// {{/export_part}}
/// ```
class BlockTag extends Tag {
  const BlockTag({
    required super.name,
    required super.attributes,
    required this.content,
    super.rawAttributes,
  });

  /// Creates a [BlockTag] from a regex match.
  factory BlockTag.fromMatch(Match match) {
    final (
    String tag,
    String rawAttributes,
    Map<String, String> attributes,
    String content,
    ) = Tag._parseMatchWithTag(match);

    return BlockTag(
      name: tag,
      attributes: attributes,
      content: content,
      rawAttributes: rawAttributes,
    );
  }

  /// Inner content of the block.
  final String content;

  /// Regex pattern for block tags with any word-like name.
  static RegExp get pattern => TagPatterns.block(r'(\w+)');
}

/// Specialized class for insertion tags.
///
/// Example:
/// ```xml
/// {{insertion_part file=tg.madt id=1}}
/// ```
///
/// Inserts code from another template file marked with the
/// [ExportPartTag].
///
/// [file] — the template file where the exported fragment will be searched.
/// [id] — the identifier of the code fragment to extract.
///
/// Matches the [id] of this tag with the [id] provided by [ExportPartTag].
class InsertionPartTag extends SelfClosingTag {
  InsertionPartTag(Map<String, String> attributes)
      : file = attributes['file'] ?? '',
        id = attributes['id'] ?? '',
        super(name: _tagName, attributes: attributes);

  /// Creates an [InsertionPartTag] from a regex match.
  factory InsertionPartTag.fromMatch(Match match) {
    final (_, Map<String, String> attributes, _) = Tag._parseMatch(match);

    return InsertionPartTag(attributes);
  }

  /// Template file name to pull the fragment from.
  final String file;

  /// Identifier of the code fragment to insert.
  final String id;

  static const String _tagName = 'insertion_part';

  /// Regex pattern for the insertion tag.
  static RegExp get pattern => TagPatterns.selfClosing(_tagName);
}

/// Specialized class for conditional tags.
///
/// Example:
/// ```xml
/// {{if $split}}
///   SomeCode
/// {{/if}}
/// ```
///
/// A condition for displaying content based on a parameter.
///
/// [condition] — the condition to evaluate before rendering content.
class IfTag extends BlockTag {
  const IfTag({required this.condition, required super.content})
      : super(
    name: _tagName,
    attributes: const <String, String>{},
    rawAttributes: condition,
  );

  /// Creates an [IfTag] from a regex match.
  factory IfTag.fromMatch(Match match) {
    final (String condition, _, String content) = Tag._parseMatch(match);

    return IfTag(condition: condition, content: content);
  }

  /// Raw condition string, e.g. `"not $flag"` or `"$flag"`.
  final String condition;

  static const String _tagName = 'if';

  /// Regex pattern for the `if` block.
  static RegExp get pattern => TagPatterns.block(_tagName);

  /// Evaluates the condition based on the provided parameters.
  ///
  /// [params] — a map of parameters used to check the condition.
  ///
  /// Returns `true` if the condition holds, otherwise `false`.
  bool evaluateCondition(Map<String, dynamic> params) {
    final List<String> parts = condition.split(' ');
    if (parts.isEmpty) {
      return false;
    }

    final String variable = parts.last.replaceFirst('\$', '');
    final bool result = params.containsKey(variable) && params[variable] as bool;

    return parts.first == 'not' ? !result : result;
  }

  /// Extracts the variable name referenced in the condition, if any.
  String? get variable {
    final List<String> parts = condition.split(' ');
    if (parts.isEmpty) {
      return null;
    }

    return parts.last.replaceFirst('\$', '');
  }

  /// Returns the content if the condition evaluates to `true`,
  /// otherwise returns an empty string.
  ///
  /// [params] — a map of parameters used to check the condition.
  String evaluateContent(Map<String, dynamic> params) {
    return evaluateCondition(params) ? content : '';
  }
}

/// Specialized class for export tags.
///
/// Example:
/// ```xml
/// {{export_part id=1}}
/// Some code
/// {{/export_part}}
/// ```
///
/// Exports a code fragment for later insertion.
///
/// [id] — the identifier of the code fragment to export.
class ExportPartTag extends BlockTag {
  ExportPartTag({required super.attributes, required super.content})
      : id = attributes['id'] ?? '',
        super(name: _tagName);

  /// Creates an [ExportPartTag] from a regex match.
  factory ExportPartTag.fromMatch(Match match) {
    final (_, Map<String, String> attributes, String content) = Tag._parseMatch(match);

    return ExportPartTag(attributes: attributes, content: content);
  }

  /// Identifier of the exported fragment.
  final String id;

  static const String _tagName = 'export_part';

  /// Regex pattern for the export tag.
  static RegExp get pattern => TagPatterns.block(_tagName);
}
