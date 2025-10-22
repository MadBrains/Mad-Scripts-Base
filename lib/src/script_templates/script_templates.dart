import 'package:mad_scripts_base/mad_scripts_base.dart';
import 'package:mustache_template/mustache.dart';
// ignore: implementation_imports
import 'package:mustache_template/src/template.dart' as t;

import 'mtl/mtl.dart';

/// The `ScriptTemplates` class provides utilities for reading and rendering
/// Mustache templates from files or raw strings.
///
/// Example:
/// ```dart
/// final data = {'foo': 'Test'};
/// final rendered = ScriptTemplates.fromString('{{foo}} is important', values: data); // Test is important
/// ```
class ScriptTemplates {
  static String templatesPath = '';

  /// Reads a Mustache template from a file and renders it with the provided data.
  ///
  /// [file]: File name (without the `.mustache` extension).
  /// [values]: Data used to render the template.
  /// [path]: Optional. Directory where templates are stored. Defaults to [templatesPath].
  /// [lenient]: Optional. If `true`, template errors are ignored. Defaults to `false`.
  /// [name]: Optional. Template name.
  /// [partialResolver]: Optional. Resolver for handling partial templates.
  ///
  /// Returns the rendered template as a string.
  static String fromFile(
      String file, {
        required Map<String, dynamic> values,
        String? path,
        bool lenient = false,
        String? name,
        PartialResolver? partialResolver,
      }) {
    final finalPath = path ?? templatesPath;
    final String fullPath = '$finalPath/$file.mustache';
    output.debug(fullPath);

    final String source = MTL.readTemplate(fullPath);

    return fromString(
      source,
      values: values,
      path: finalPath,
      lenient: lenient,
      name: name,
      partialResolver: partialResolver,
    );
  }

  /// Renders a Mustache template from a raw string.
  ///
  /// [source]: Template as a string.
  /// [values]: Data used to render the template.
  /// [path]: Optional. Directory where templates are stored. Defaults to [templatesPath].
  /// [lenient]: Optional. If `true`, template errors are ignored. Defaults to `false`.
  /// [htmlEscapeValues]: Optional. Whether to HTML-escape values. Defaults to `false`.
  /// [name]: Optional. Template name.
  /// [partialResolver]: Optional. Resolver for handling partial templates.
  ///
  /// Returns the rendered template as a string.
  static String fromString(
      String source, {
        required Map<String, dynamic> values,
        String? path,
        bool lenient = false,
        bool htmlEscapeValues = false,
        String? name,
        PartialResolver? partialResolver,
      }) {
    final finalPath = path ?? templatesPath;
    final String readySource = MTL.prepareTemplateFromString(source, path: finalPath);
    final t.Template template = t.Template.fromSource(
      readySource,
      lenient: lenient,
      name: name,
      partialResolver: partialResolver,
      htmlEscapeValues: htmlEscapeValues,
    );

    return template.renderString(values);
  }
}
