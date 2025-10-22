/// Exception used for handling errors in scripts.
class ScriptException implements Exception {
  /// Creates an instance of `ScriptException` with the provided error message.
  const ScriptException(this.message);

  /// The error message.
  final String message;

  /// Returns a string representation of the exception in the format `ScriptException: message`.
  @override
  String toString() {
    return 'ScriptException: $message\n';
  }
}

/// Exception thrown when a field already exists.
class FieldExistsException implements ScriptException {
  const FieldExistsException();

  @override
  String get message => 'Field already exists';
}
