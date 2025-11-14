import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'log_event.dart';

abstract class Logger {
  void logRequest(RequestEvent event);
  void logResponse(ResponseEvent event);
  void logError(ErrorEvent event);
  void logStateChange(StateChangeEvent event);
}

class CanonicalLogger implements Logger {
  static const String _canonicalPrefix = 'canonical-log-line';

  @override
  void logRequest(RequestEvent event) {
    _emit({
      'event_type': 'request',
      'request_id': event.id,
      'operation': event.operation,
      'parameters': event.parameters,
      'timestamp': event.timestamp.toIso8601String(),
      ...event.metadata,
    });
  }

  @override
  void logResponse(ResponseEvent event) {
    _emit({
      'event_type': 'response',
      'request_id': event.requestId,
      'duration_ms': event.durationMs,
      'status': event.status,
      if (event.itemCount != null) 'item_count': event.itemCount,
      'timestamp': event.timestamp.toIso8601String(),
      ...event.metadata,
    });
  }

  @override
  void logError(ErrorEvent event) {
    _emit({
      'event_type': 'error',
      'request_id': event.requestId,
      'error_type': event.errorType,
      'message': event.message,
      if (event.stackTrace != null) 'stack_trace': event.stackTrace.toString(),
      'timestamp': event.timestamp.toIso8601String(),
      ...event.metadata,
    });
  }

  @override
  void logStateChange(StateChangeEvent event) {
    if (!kDebugMode) return;

    _emit({
      'event_type': 'state_change',
      'bloc': event.bloc,
      'from_state': event.fromState,
      'to_state': event.toState,
      if (event.event != null) 'event': event.event,
      'timestamp': event.timestamp.toIso8601String(),
      ...event.metadata,
    });
  }

  void _emit(Map<String, dynamic> logLine) {
    if (kDebugMode) {
      debugPrint('$_canonicalPrefix ${jsonEncode(logLine)}');
    }
  }
}

class NoOpLogger implements Logger {
  @override
  void logRequest(RequestEvent event) {}

  @override
  void logResponse(ResponseEvent event) {}

  @override
  void logError(ErrorEvent event) {}

  @override
  void logStateChange(StateChangeEvent event) {}
}
