import 'package:analyzer/dart/ast/ast.dart';
import 'package:mad_scripts_base/src/src.dart';

/// Extension for the [ClassDeclaration] class from the [analyzer] package.
/// Adds helper methods for working with class members.
extension ClassNodeExtension on ClassDeclaration {
  /// Returns a list of all fields in the class.
  ///
  /// Fields are represented as [FieldDeclaration] objects.
  ///
  /// **Return value**:
  /// - `List<FieldDeclaration>`: A non-empty list of class fields.
  List<FieldDeclaration> getFields() => members.whereType<FieldDeclaration>().toList(growable: false);

  /// Returns a class method by its name.
  ///
  /// If a method with the specified name is not found, returns `null`.
  ///
  /// [name] - The name of the method to find.
  ///
  /// **Return value**:
  /// - `MethodDeclaration?`: The method with the given name, or `null` if not found.
  MethodDeclaration? getMethod(String name) =>
      members.firstWhereOrNull((ClassMember node) => node is MethodDeclaration && node.name.lexeme == name)
      as MethodDeclaration?;

  /// Returns the function body of a method by its name.
  ///
  /// If a method with the specified name is not found or has no body, returns `null`.
  ///
  /// [name] - The name of the method whose body should be retrieved.
  ///
  /// **Return value**:
  /// - `FunctionBody?`: The body of the method with the given name, or `null` if not found or has no body.
  FunctionBody? getFunctionBodyByName(String name) {
    final MethodDeclaration? method = getMethod(name);
    if (method == null) return null;

    return method.body;
  }
}
