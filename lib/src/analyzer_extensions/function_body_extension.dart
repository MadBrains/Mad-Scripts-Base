import 'package:analyzer/dart/ast/ast.dart';
import 'package:mad_scripts_base/src/analyzer_extensions/extensions.dart';
import 'package:mad_scripts_base/src/src.dart';

/// Extension for the [FunctionBody] class from the [analyzer] package.
/// Adds helper methods for working with different types of function bodies.
extension FunctionBlockBodyExt on FunctionBody {
  /// Returns the function body of type [BlockFunctionBody] if the current node is such.
  ///
  /// **Return value**:
  /// - `BlockFunctionBody?`: The function body of type [BlockFunctionBody], or `null` if not applicable.
  BlockFunctionBody? getBlockBody() => getNodeOfExactType<BlockFunctionBody>();

  /// Returns the function body of type [EmptyFunctionBody] if the current node is such.
  ///
  /// **Return value**:
  /// - `EmptyFunctionBody?`: The function body of type [EmptyFunctionBody], or `null` if not applicable.
  EmptyFunctionBody? getEmptyBody() => getNodeOfExactType<EmptyFunctionBody>();

  /// Returns the function body of type [ExpressionFunctionBody] if the current node is such.
  ///
  /// **Return value**:
  /// - `ExpressionFunctionBody?`: The function body of type [ExpressionFunctionBody], or `null` if not applicable.
  ExpressionFunctionBody? getExpressionBody() => getNodeOfExactType<ExpressionFunctionBody>();
}

/// Extension for the [BlockFunctionBody] class from the [analyzer] package.
/// Adds helper methods for working with return statements in block-style function bodies.
extension BlockFunctionBodyExt on BlockFunctionBody {
  /// Returns the return statement from the function block, if present.
  ///
  /// If no return statement is found, returns `null`.
  ///
  /// **Return value**:
  /// - `ReturnStatement?`: The return statement from the function block, or `null` if not found.
  ReturnStatement? getReturnStatement() =>
      block.statements.firstWhereOrNull((Statement statement) => statement is ReturnStatement) as ReturnStatement?;

  /// Returns the expression from the return statement if it matches the type [T].
  ///
  /// If the return statement is not found or the expression does not match type [T], returns `null`.
  ///
  /// [T] - The expected type of the expression.
  ///
  /// **Return value**:
  /// - `T?`: The expression from the return statement of type [T], or `null` if not found or of a different type.
  T? getReturnStatementExpressionOfExactType<T>() {
    final ReturnStatement? returnStatement = getReturnStatement();

    if (returnStatement != null) {
      return returnStatement.expression?.getNodeOfExactType<T>();
    }

    return null;
  }
}

/// Extension for the [ExpressionFunctionBody] class from the [analyzer] package.
/// Adds helper methods for working with expressions in single-expression function bodies.
extension ExpressionFunctionBodyExt on ExpressionFunctionBody {
  /// Returns the expression of the function body if it matches the type [T].
  ///
  /// **Return value**:
  /// - `T?`: The expression of type [T], or `null` if it does not match the type.
  T? getExpressionOfExactType<T>() => expression.getNodeOfExactType<T>();
}
