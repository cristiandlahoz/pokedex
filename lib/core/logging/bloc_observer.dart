import 'package:flutter_bloc/flutter_bloc.dart';
import 'logger.dart';
import 'log_event.dart';

class CanonicalBlocObserver extends BlocObserver {
  final Logger logger;

  CanonicalBlocObserver(this.logger);

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.logStateChange(
      StateChangeEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        bloc: bloc.runtimeType.toString(),
        fromState: bloc.state.runtimeType.toString(),
        toState: 'processing',
        event: event.runtimeType.toString(),
      ),
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.logError(
      ErrorEvent(
        requestId: DateTime.now().millisecondsSinceEpoch.toString(),
        errorType: error.runtimeType.toString(),
        message: error.toString(),
        stackTrace: stackTrace,
        metadata: {'bloc': bloc.runtimeType.toString()},
      ),
    );
  }
}
