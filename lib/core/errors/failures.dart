abstract class Failure {
  final String message;
  final dynamic originalError;

  const Failure(this.message, {this.originalError});

  @override
  String toString() => '$runtimeType: $message';
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode, super.originalError});

  @override
  String toString() => 'ServerFailure($statusCode): $message';
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.originalError});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.originalError});
}

class ValidationFailure extends Failure {
  final String? field;

  const ValidationFailure(super.message, {this.field, super.originalError});
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.originalError});
}
