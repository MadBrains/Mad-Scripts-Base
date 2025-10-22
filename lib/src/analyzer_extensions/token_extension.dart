import 'package:analyzer/dart/ast/token.dart';

/// Extension for the [Token] class from the [analyzer] package.
/// Adds helper methods for working with tokens.
extension TokenExt on Token {
  /// Checks whether the previous token is a comma.
  ///
  /// **Return value**:
  /// - `bool`: `true` if the previous token is a comma, otherwise `false`.
  bool get previousIsComma => previous?.type == TokenType.COMMA;

  /// Checks whether the next token is a comma.
  ///
  /// **Return value**:
  /// - `bool`: `true` if the next token is a comma, otherwise `false`.
  bool get nextIsComma => next?.type == TokenType.COMMA;

  /// Returns the offset of the previous token relative to the current one.
  ///
  /// The offset is calculated as the current offset minus 1.
  ///
  /// **Return value**:
  /// - `int`: The offset of the previous token.
  int get previousOffset => offset - 1;
}

