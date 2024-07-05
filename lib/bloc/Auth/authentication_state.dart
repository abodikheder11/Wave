import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final String userId;

  const AuthenticationAuthenticated({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  final String error;

  const AuthenticationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
