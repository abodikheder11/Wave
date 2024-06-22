part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpState  extends Equatable{
@override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}


class SignUpLoading extends SignUpState {}


class SignUpSuccess extends SignUpState {}


class SignUpFailure extends SignUpState {

  final String error;
  SignUpFailure(this.error);

  @override
  List<Object> get props => [error];
}


