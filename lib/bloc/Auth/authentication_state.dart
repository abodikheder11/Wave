// authentication_state.dart

part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String userId;

  AuthenticationSuccess({required this.userId});
}

class AuthenticationFailure extends AuthenticationState {
  final String error;

  AuthenticationFailure({required this.error});
}

class RegisteredUsersLoaded extends AuthenticationState {
  final List<String> registeredUserNumbers;

  RegisteredUsersLoaded(this.registeredUserNumbers);
}
