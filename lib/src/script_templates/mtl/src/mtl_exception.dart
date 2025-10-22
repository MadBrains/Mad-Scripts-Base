abstract class MTLException implements Exception {
  const MTLException(this.originalError, this.stackTrace);

  final StackTrace stackTrace;
  final dynamic originalError;

  abstract final String message;
}

final class MTLExceptionUnknown extends MTLException {
  const MTLExceptionUnknown(super.originalError, super.stackTrace);

  @override
  String get message => 'Unknown Error';
}

final class MTLParseException extends MTLException {
  const MTLParseException(super.originalError, super.stackTrace);

  @override
  String get message => "Can't parse template. Try to check your template!";
}
