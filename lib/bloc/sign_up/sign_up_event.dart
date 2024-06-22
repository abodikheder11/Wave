part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class SignUpSubmitted extends SignUpEvent{
  final String email;
  final String password;

  SignUpSubmitted(this.email, this.password);
}