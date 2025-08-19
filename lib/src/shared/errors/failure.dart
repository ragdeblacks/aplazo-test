import 'package:equatable/equatable.dart';

/// Base class for controlled domain/application errors
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const Failure({required this.message, this.code, this.details});

  @override
  List<Object?> get props => [message, code, details];
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code, super.details});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({required super.message, super.code, super.details});
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({required super.message, this.statusCode, super.code, super.details});

  @override
  List<Object?> get props => [message, code, details, statusCode];
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message, super.code, super.details});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.code, super.details});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code, super.details});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code, super.details});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message, super.code, super.details});
}
