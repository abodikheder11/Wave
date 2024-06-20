part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class PickFileEvent extends ChatEvent {}

class PickImageEvent extends ChatEvent {}

class UploadFileEvent extends ChatEvent {
  final File file;

  const UploadFileEvent(this.file);

  @override
  List<Object> get props => [file];
}

