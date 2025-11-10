import 'package:graphql/client.dart';

abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException(this.message, {this.code});
  
  @override
  String toString() => 'AppException: $message${code != null ? ' (code: $code)' : ''}';
}

class GraphQLException extends AppException {
  const GraphQLException(super.message, {super.code});
  
  factory GraphQLException.fromResult(QueryResult result) {
    final errors = result.exception?.graphqlErrors;
    if (errors != null && errors.isNotEmpty) {
      return GraphQLException(
        errors.first.message,
        code: errors.first.extensions?['code']?.toString(),
      );
    }
    
    final linkException = result.exception?.linkException;
    if (linkException != null) {
      return GraphQLException('Network error: ${linkException.toString()}');
    }
    
    return const GraphQLException('Unknown GraphQL error');
  }
}

class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}
