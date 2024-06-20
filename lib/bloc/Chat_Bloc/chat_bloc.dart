import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import '../../data/models/messages.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<PickFileEvent>(_onPickFileEvent);
    on<PickImageEvent>(_onPickImageEvent);
    on<UploadFileEvent>(_onUploadFileEvent);
  }

  Future<void> _onPickFileEvent(PickFileEvent event, Emitter<ChatState> emit) async {
    print('PickFileEvent received');
    emit(ChatLoading());
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        print('File picked: ${file.path}');
        add(UploadFileEvent(file));
      } else {
        emit(ChatInitial()); // No file picked
      }
    } catch (error) {
      print('Error picking file: $error');
      emit(ChatError(error.toString()));
    }
  }

  Future<void> _onPickImageEvent(PickImageEvent event, Emitter<ChatState> emit) async {
    print('PickImageEvent received');
    emit(ChatLoading());
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File file = File(image.path);
        print('Image picked: ${file.path}');
        add(UploadFileEvent(file));
      } else {
        emit(ChatInitial()); // No image picked
      }
    } catch (error) {
      print('Error picking image: $error');
      emit(ChatError(error.toString()));
    }
  }

  Future<void> _onUploadFileEvent(UploadFileEvent event, Emitter<ChatState> emit) async {
    print('UploadFileEvent received for file: ${event.file.path}');
    emit(ChatLoading());
    try {
      // Simulate file upload by waiting for a second
      await Future.delayed(Duration(seconds: 1));
      print('File uploaded: ${event.file.path}');
      emit(ChatLoaded([Message(event.file.path, false, DateFormat("hh:mm a").format(DateTime.now()), isImage: true)]));
    } catch (error) {
      print('Error uploading file: $error');
      emit(ChatError(error.toString()));
    }
  }
}


