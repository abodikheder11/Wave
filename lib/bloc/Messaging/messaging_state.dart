// messaging_state.dart
import 'package:aboditest/data/models/messages.dart';
import 'package:equatable/equatable.dart';

abstract class MessagingState extends Equatable {
  const MessagingState();

  @override
  List<Object> get props => [];
}

class MessagingInitial extends MessagingState {}

class MessagingLoading extends MessagingState {}

class MessageSent extends MessagingState {
  final String message;
  final MessageStatus status;

  const MessageSent(this.message , {this.status = MessageStatus.sent});

  @override
  List<Object> get props => [message];
}

class MessagingError extends MessagingState {
  final String error;

  const MessagingError(this.error);

  @override
  List<Object> get props => [error];
}
