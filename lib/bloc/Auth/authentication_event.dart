part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticationStarted extends AuthenticationEvent {
  final String userId;

  AuthenticationStarted({required this.userId});
}

class AuthenticationLoggedIn extends AuthenticationEvent {
  final String userId;

  AuthenticationLoggedIn({required this.userId});
}

class AuthenticationLoggedOut extends AuthenticationEvent {}

class FetchRegisteredUsers extends AuthenticationEvent {
  final String userId;

  FetchRegisteredUsers({required this.userId});
}
