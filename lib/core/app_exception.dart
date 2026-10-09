/// An error with a message that is safe to show to the user.
class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException: $message (cause: $cause)';
}