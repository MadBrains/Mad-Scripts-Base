import 'package:analyzer/dart/ast/ast.dart';

/// Extension for the [AstNode] class from the [analyzer] package.
/// Adds helper methods for working with AST nodes.
extension AstNodeExt on AstNode {
  /// Returns a node of type [T] if the current node is an instance of that type.
  /// If the node does not match the type [T], returns `null`.
  ///
  /// [T] - The type of node to retrieve.
  ///
  /// Example usage:
  /// ```dart
  /// var node = someAstNode.getNodeOfExactType<FunctionDeclaration>();
  /// if (node != null) {
  ///   // The node is a FunctionDeclaration
  /// }
  /// ```
  T? getNodeOfExactType<T>() {
    if (this is T) {
      return this as T;
    }

    return null;
  }
}
