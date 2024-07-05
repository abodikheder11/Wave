import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {
  final String username;
  final String password;

  const AuthenticationLoggedIn({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class AuthenticationLoggedOut extends AuthenticationEvent {}

class AuthenticationSignedUp extends AuthenticationEvent {
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final String confPassword;
  final String gender;

  const AuthenticationSignedUp({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confPassword,
    required this.gender,
  });

  @override
  List<Object> get props => [fullName, username, email, phoneNumber, password, confPassword, gender];
}
