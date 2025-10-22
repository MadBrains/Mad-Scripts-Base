import 'dart:io';

import 'package:mad_scripts_base/src/script_templates/mtl/src/src.dart';

/// MTL (Mad Template Language) - класс для работы с шаблонами.
class MTL {
  /// Читает шаблон из файла и возвращает его содержимое в виде строки.
  ///
  /// [file] - путь к файлу шаблона.
  static String readTemplate(String file) => File(file).readAsStringSync();

  /// Подготавливает шаблон, обрабатывает условия и вставки.
  ///
  /// [file] - путь к файлу шаблона.
  /// [templateMatches] - карта заменяемых значений в шаблоне.
  /// [params] - параметры для условных конструкций.
  static String prepareTemplate(
    String file, {
    Map<String, String> templateMatches = const <String, String>{},
    Map<String, dynamic> params = const <String, dynamic>{},
    required String path,
  }) {
    final String template = readTemplate(file);

    return prepareTemplateFromString(
      template,
      templateMatches: templateMatches,
      params: params,
      path: path,
    );
  }

  /// Подготавливает шаблон из строки, заменяя параметры и вставки.
  ///
  /// [content] - содержимое шаблона.
  /// [templateMatches] - карта заменяемых значений в шаблоне.
  /// [params] - параметры для условных конструкций.
  static String prepareTemplateFromString(
    String template, {
    Map<String, String> templateMatches = const <String, String>{},
    Map<String, dynamic> params = const <String, dynamic>{},
    required String path,
  }) {
    String content = template;

    content = processInsertions(content, path);

    /// ADD NEW TAGS HER

    return clearFromTags(content);
  }

  /// Обрабатывает условные конструкции в шаблоне.
  ///
  /// [template] - содержимое шаблона.
  /// [params] - параметры для условных конструкций.
  static String processConditions(
    String template,
    Map<String, dynamic> params,
  ) {
    try {
      return template.parseTags<IfTag>((IfTag tag) {
        return tag.evaluateContent(params);
      });
    } catch (error, stackTrace) {
      throw MTLParseException(error, stackTrace);
    }
  }

  /// Обрабатывает вставки в шаблоне.
  ///
  /// [template] - содержимое шаблона.
  /// [templateMatches] - карта заменяемых значений в шаблоне.
  static String processInsertions(String template, String path) {
    try {
      return template.parseTags<InsertionPartTag>((InsertionPartTag tag) {
        final String insertionContent = readTemplate('$path/${tag.file}.mustache');

        final List<ExportPartTag> exportTags =
            insertionContent.findTagsWhere((ExportPartTag exportTag) => exportTag.id == tag.id);

        if (exportTags.isEmpty) return '';

        return processInsertions(exportTags.first.content, path);
      });
    } catch (error, stackTrace) {
      throw MTLParseException(error, stackTrace);
    }
  }

  /// Очищает код от всех оставшихся тэгов.
  ///
  /// [template] - содержимое шаблона.
  static String clearFromTags(String template) {
    try {
      /// ADD NEW TAGS HER
      return template
          .parseTags<InsertionPartTag>((_) => '')
          .parseTags<ExportPartTag>((BlockTag tag) => tag.content)
          .parseTags<IfTag>((IfTag tag) => tag.content);
    } catch (error, stackTrace) {
      throw MTLParseException(error, stackTrace);
    }
  }
}
