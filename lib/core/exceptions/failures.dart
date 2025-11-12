import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final StackTrace? stackTrace;
  final Object? originalError;
  
  const Failure(
    this.message, {
    this.stackTrace,
    this.originalError,
  });
  
  @override
  List<Object?> get props => [message, stackTrace, originalError];
  
  @override
  String toString() => message;

  String toDetailedString() {
    final buffer = StringBuffer();
    buffer.writeln('Error: $message');
    if (originalError != null) {
      buffer.writeln('Original error: $originalError');
    }
    if (stackTrace != null) {
      buffer.writeln('Stack trace:\n$stackTrace');
    }
    return buffer.toString();
  }
}

class ServerFailure extends Failure {
  const ServerFailure(
    super.message, {
    super.stackTrace,
    super.originalError,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure(
    super.message, {
    super.stackTrace,
    super.originalError,
  });
}

class CacheFailure extends Failure {
  const CacheFailure(
    super.message, {
    super.stackTrace,
    super.originalError,
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(
    super.message, {
    super.stackTrace,
    super.originalError,
  });
}
