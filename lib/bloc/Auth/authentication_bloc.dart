import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../data/services/user_repo.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository}) : super(AuthenticationInitial()) {
    on<AuthenticationStarted>(_onAuthenticationStarted);
    on<AuthenticationLoggedIn>(_onAuthenticationLoggedIn);
    on<AuthenticationLoggedOut>(_onAuthenticationLoggedOut);
    on<AuthenticationSignedUp>(_onAuthenticationSignedUp);
  }

  Future<void> _onAuthenticationStarted(
      AuthenticationStarted event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationInitial());
  }

  Future<void> _onAuthenticationLoggedIn(
      AuthenticationLoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      final userId = await userRepository.login(
        username: event.username,
        password: event.password,
      );
      emit(AuthenticationAuthenticated(userId: userId));
    } catch (error) {
      emit(AuthenticationFailure(error: error.toString()));
    }
  }

  Future<void> _onAuthenticationLoggedOut(
      AuthenticationLoggedOut event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      await userRepository.logout();
      emit(AuthenticationUnauthenticated());
    } catch (error) {
      emit(AuthenticationFailure(error: error.toString()));
    }
  }

  Future<void> _onAuthenticationSignedUp(
      AuthenticationSignedUp event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      final userId = await userRepository.signup(
        fullName: event.fullName,
        username: event.username,
        email: event.email,
        phoneNumber: event.phoneNumber,
        password: event.password,
        confPassword: event.confPassword,
        gender: event.gender,
      );
      emit(AuthenticationAuthenticated(userId: userId));
    } catch (error) {
      emit(AuthenticationFailure(error: error.toString()));
    }
  }
}
