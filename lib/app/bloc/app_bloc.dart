import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> with ChangeNotifier {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(AppState(user: authenticationRepository.currentUser)) {
    on<AppUserSubscriptionRequested>(_onUserSubscriptionRequested);
    on<AppLogoutPressed>(_onLogoutPressed);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onUserSubscriptionRequested(
    AppUserSubscriptionRequested event,
    Emitter<AppState> emit,
  ) async {
    return emit.onEach(
      _authenticationRepository.user,
      onData: (user) {
        emit(AppState(user: user));
        notifyListeners();
      },
      onError: addError,
    );
  }

  Future<void> _onLogoutPressed(
    AppLogoutPressed event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _authenticationRepository.logOut();
    } catch (e) {
      print("Error during logout: $e");
    } finally {
      notifyListeners();
    }
  }
}
