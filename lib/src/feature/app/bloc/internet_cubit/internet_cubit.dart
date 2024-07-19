import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum InternetState {
  initial,
  connected,
  disconnected,
}

/// This cubit is needed to notify user about
/// internet connection state, so that he can be aware
/// of availability of data syncrhronization
//
//  Though, we don't use it for error handling
//  only for polite notifying user about connection state
class InternetCubit extends Cubit<InternetState> {
  final connectivity = Connectivity();
  late final StreamSubscription<List<ConnectivityResult>>? connectSubscription;

  InternetCubit() : super(InternetState.initial) {
    subscribeOnConnectivityChanged();
  }

  void subscribeOnConnectivityChanged() {
    connectSubscription = connectivity.onConnectivityChanged.listen(
      (result) {
        if (result.contains(ConnectivityResult.mobile) ||
            result.contains(ConnectivityResult.wifi) ||
            result.contains(ConnectivityResult.ethernet) ||
            result.contains(ConnectivityResult.vpn)) {
          emit(InternetState.connected);
        } else {
          emit(InternetState.disconnected);
        }
      },
    );
  }

  @override
  Future<void> close() {
    connectSubscription?.cancel();
    return super.close();
  }
}
