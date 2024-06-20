// messaging_event.dart
import 'package:equatable/equatable.dart';

import '../../data/models/messages.dart';

abstract class MessagingEvent extends Equatable {
  const MessagingEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends MessagingEvent {
  final String message;
  final MessageStatus status;

  const SendMessageEvent(this.message , {this.status = MessageStatus.sent});

  @override
  List<Object> get props => [message ,status];
}
