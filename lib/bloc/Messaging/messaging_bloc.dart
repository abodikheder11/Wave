import 'package:bloc/bloc.dart';
import 'messaging_event.dart';
import 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  MessagingBloc() : super(MessagingInitial()) {
    on<SendMessageEvent>(_onSendMessageEvent);
  }

  Future<void> _onSendMessageEvent(SendMessageEvent event, Emitter<MessagingState> emit) async {
    emit(MessagingLoading());
    try {
      emit(MessageSent(event.message));
    } catch (error) {
      emit(MessagingError(error.toString()));
    }
  }
}
