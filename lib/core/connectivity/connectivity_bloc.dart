import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'connectivity_service.dart';

sealed class ConnectivityEvent {}

class ConnectivityCheckRequested extends ConnectivityEvent {}

class ConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;

  ConnectivityChanged(this.isConnected);
}

sealed class ConnectivityState {
  final bool isOnline;

  const ConnectivityState(this.isOnline);
}

class ConnectivityOnline extends ConnectivityState {
  const ConnectivityOnline() : super(true);
}

class ConnectivityOffline extends ConnectivityState {
  const ConnectivityOffline() : super(false);
}

class ConnectivityUnknown extends ConnectivityState {
  const ConnectivityUnknown() : super(false);
}

@injectable
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService service;

  ConnectivityBloc({required this.service})
    : super(const ConnectivityUnknown()) {
    on<ConnectivityCheckRequested>(_onCheckRequested);
    on<ConnectivityChanged>(_onConnectivityChanged);

    service.connectivityStream.listen((isConnected) {
      add(ConnectivityChanged(isConnected));
    });
  }

  Future<void> _onCheckRequested(
    ConnectivityCheckRequested event,
    Emitter<ConnectivityState> emit,
  ) async {
    final isConnected = await service.isConnected;
    emit(
      isConnected ? const ConnectivityOnline() : const ConnectivityOffline(),
    );
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    emit(
      event.isConnected
          ? const ConnectivityOnline()
          : const ConnectivityOffline(),
    );
  }
}
