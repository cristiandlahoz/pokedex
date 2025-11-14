sealed class LogEvent {
  final String id;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  LogEvent({
    required this.id,
    required this.timestamp,
    this.metadata = const {},
  });
}

class RequestEvent extends LogEvent {
  final String operation;
  final Map<String, dynamic> parameters;

  RequestEvent({
    required super.id,
    required this.operation,
    this.parameters = const {},
    super.metadata,
  }) : super(timestamp: DateTime.now());
}

class ResponseEvent extends LogEvent {
  final String requestId;
  final int durationMs;
  final String status;
  final int? itemCount;

  ResponseEvent({
    required this.requestId,
    required this.durationMs,
    required this.status,
    this.itemCount,
    super.metadata,
  }) : super(
          id: requestId,
          timestamp: DateTime.now(),
        );
}

class ErrorEvent extends LogEvent {
  final String requestId;
  final String errorType;
  final String message;
  final StackTrace? stackTrace;

  ErrorEvent({
    required this.requestId,
    required this.errorType,
    required this.message,
    this.stackTrace,
    super.metadata,
  }) : super(
          id: requestId,
          timestamp: DateTime.now(),
        );
}

class StateChangeEvent extends LogEvent {
  final String bloc;
  final String fromState;
  final String toState;
  final String? event;

  StateChangeEvent({
    required super.id,
    required this.bloc,
    required this.fromState,
    required this.toState,
    this.event,
    super.metadata,
  }) : super(timestamp: DateTime.now());
}
