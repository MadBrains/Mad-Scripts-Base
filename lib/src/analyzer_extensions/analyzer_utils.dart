import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:mad_scripts_base/mad_scripts_base.dart';

/// Утилитный класс для работы с анализатором Dart и обновлениями файлов.
class AnalyzerUtils {
  /// Обновляет директиву `export` в указанном файле, добавляя новую директиву экспорта.
  ///
  /// Если директива экспорта уже присутствует в файле, возвращается исходное содержимое файла.
  /// В противном случае добавляется новая директива экспорта в конец файла.
  ///
  /// Параметры:
  /// - [path] (`String`): Путь к файлу, в который нужно добавить директиву.
  /// - [exportFile] (`String`): Имя файла, который нужно экспортировать.
  ///
  /// Возвращает:
  /// - `String`: Обновленное содержимое файла с новой директивой экспорта.
  static String updateExportsInFile({required String path, required String exportFile}) {
    final String newExport = "export '$exportFile';";
    final File contentFile = File(path);
    if (!contentFile.existsSync()) {
      return newExport;
    }
    final String content = contentFile.readAsStringSync();
    if (content.contains(newExport)) {
      return content;
    }
    final SomeParsedUnitResult unitResult = getParsedUnit(path);
    if (unitResult is ParsedUnitResult) {
      final CompilationUnit unit = unitResult.unit;
      final NodeList<Directive> directives = unit.directives;
      final Directive? lastDirective = directives.lastWhereOrNull(
        (Directive directive) => directive is ExportDirective,
      );
      if (lastDirective != null) {
        final int endOffset = lastDirective.end;
        final String updatedExports = '${content.substring(0, endOffset)}\n$newExport${content.substring(endOffset)}';

        return updatedExports;
      }
    }

    return newExport;
  }

  /// Получает разобранный единичный модуль Dart для указанного пути.
  ///
  /// Параметры:
  /// - [path] (`String`): Путь к файлу для анализа.
  ///
  /// Возвращает:
  /// - `SomeParsedUnitResult`: Результат разбора единичного модуля.
  static SomeParsedUnitResult getParsedUnit(String path) {
    final File file = File(path.replaceFirst('./', ''));
    final String absolutePath = file.absolute.path;
    final AnalysisContextCollection collection = AnalysisContextCollection(includedPaths: <String>[absolutePath]);
    final AnalysisContext context = collection.contextFor(absolutePath);
    final AnalysisSession session = context.currentSession;

    return session.getParsedUnit(absolutePath);
  }
}
