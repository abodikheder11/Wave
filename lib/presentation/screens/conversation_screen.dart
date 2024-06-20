import 'package:aboditest/presentation/widgets/conversation_appBar.dart';
import 'package:aboditest/presentation/widgets/message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

import '../../bloc/Chat_Bloc/chat_bloc.dart';
import '../../bloc/Messaging/messaging_bloc.dart';
import '../../bloc/Messaging/messaging_event.dart';
import '../../bloc/Messaging/messaging_state.dart';
import '../../data/models/conversation.dart';
import '../../data/models/messages.dart';
import '../../utils/voice_Message_Recorder.dart';
import '../widgets/emoji_reaction_popup.dart';
import '../widgets/message_input.dart';

class ConversationScreen extends StatefulWidget {
  final Conversation conversation;

  const ConversationScreen(this.conversation, {super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  OverlayEntry? _overlayEntry;
  final Map<int, GlobalKey> _messageKeys = {};
  bool _isSearchVisible = false;
  TextEditingController searchController = TextEditingController();
  int _searchMessageIndex = -1;
  bool _isRecording = false;
  final Record _audioRecorder = Record();
  List<Message> messages = [];
  VoiceMessageProvider voiceMessageProvider = VoiceMessageProvider();


  @override
  void initState() {
    super.initState();
    _requestPermissions();
    searchController.addListener(_filterMessages);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.removeListener(_filterMessages);
    searchController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/audio_${DateTime
        .now()
        .millisecondsSinceEpoch}.m4a';
    return filePath;
  }
  Future<void> _startVoiceRecording(BuildContext context) async {
    final voiceMessageProvider = Provider.of<VoiceMessageProvider>(context, listen: false);
    await voiceMessageProvider.startRecording();
  }

  Future<void> _stopVoiceRecording(BuildContext context, {bool cancelled = false}) async {
    final voiceMessageProvider = Provider.of<VoiceMessageProvider>(context, listen: false);
    final filePath = await voiceMessageProvider.stopRecording();
    if (filePath != null && !cancelled) {
      _sendVoiceMessage(context, filePath);
    }
  }

  void _sendVoiceMessage(BuildContext context, String filePath) {
    final newMessage = Message(
      filePath,
      true,
      DateFormat("hh:mm a").format(DateTime.now()),
      status: MessageStatus.sent,
    );
    context.read<MessagingBloc>().add(SendMessageEvent(newMessage.text, status: newMessage.status));
    setState(() {
      messages.add(newMessage);
    });
  }


  void _filterMessages() {
    final query = searchController.text.toLowerCase();
    setState(() {
      // Update filtered messages
    });
    if (_searchMessageIndex != -1) {
      _scrollToMessage(_searchMessageIndex);
    }
  }

  void _scrollToMessage(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(index * 72.0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  bool _shouldHighlightMessage(String messageText) {
    final query = searchController.text.toLowerCase();
    return query.isNotEmpty && messageText.toLowerCase().contains(query);
  }

  void _sendMessage(BuildContext context) {
    final text = messageController.text;
    if (text.isNotEmpty) {
      print('Dispatching SendMessageEvent');
      final newMessage = Message(
        text,
        true,
        DateFormat("hh:mm a").format(DateTime.now()),
        status: MessageStatus.sent,
      );
      context.read<MessagingBloc>().add(
          SendMessageEvent(newMessage.text, status: newMessage.status));
      messageController.clear();
      setState(() {
        messages.add(newMessage);
      });
    }
  }



  void _showEmojiPicker(BuildContext context, int messageIndex) {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry?.remove();
    }
    _overlayEntry = _createOverlayEntry(context, messageIndex);
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry(BuildContext context, int messageIndex) {
    final key = _messageKeys[messageIndex];
    if (key == null || key.currentContext == null)
      return OverlayEntry(builder: (_) => Container());

    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) =>
          Positioned(
            left: offset.dx + 20,
            top: offset.dy - 50,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
              child: Material(
                color: Colors.transparent,
                child: EmojiReactionPopup(
                  onEmojiSelected: (emoji) {
                    _onEmojiSelected(messageIndex, emoji);
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                  },
                ),
              ),
            ),
          ),
    );
  }

  void _onEmojiSelected(int messageIndex, String selectedEmoji) {
    setState(() {
      if (messages[messageIndex].reaction == selectedEmoji) {
        messages[messageIndex].reaction = null;
      } else {
        messages[messageIndex].reaction = selectedEmoji;
      }
    });
  }

  void _pickFile(BuildContext context) {
    context.read<ChatBloc>().add(PickFileEvent());
  }

  void _pickImage(BuildContext context) {
    context.read<ChatBloc>().add(PickImageEvent());
  }

  void _handleLongPress(int messageIndex, BuildContext context) {
    _showEmojiPicker(context, messageIndex);
  }

  void _handleDoubleTap(int messageIndex) {
    setState(() {
      if (messages[messageIndex].reaction == '❤️') {
        messages[messageIndex].reaction = null;
      } else {
        messages[messageIndex].reaction = '❤️';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final voiceMessageProvider = Provider.of<VoiceMessageProvider>(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_overlayEntry != null && _overlayEntry!.mounted) {
          _overlayEntry?.remove();
          _overlayEntry = null;
        }
      },
      child: Scaffold(
        appBar: ConversationAppBar(
          conversation: widget.conversation,
          isSearchVisible: _isSearchVisible,
          onSearchPressed: () {
            setState(() {
              _isSearchVisible = true;
            });
          },
          onCloseSearchPressed: () {
            setState(() {
              _isSearchVisible = false;
            });
          },
          onSearchTextChanged: (text) {
            // Implement search functionality here
          },
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_isSearchVisible)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search messages',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _isSearchVisible = false;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: BlocListener<MessagingBloc, MessagingState>(
                listener: (context, messagingState) {
                  if (messagingState is MessageSent) {
                    print('MessageSent received in BlocListener');
                    final timestamp =
                    DateFormat("hh:mm a").format(DateTime.now());
                    final newMessage = Message(
                      messagingState.message,
                      true,
                      timestamp,
                      status: messagingState.status,
                    );
                    setState(() {
                      if (!messages.any((msg) =>
                      msg.text == newMessage.text &&
                          msg.timestamp == newMessage.timestamp)) {
                        messages.add(newMessage);
                      }
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    });
                  }
                },
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, chatState) {
                    if (chatState is ChatLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (chatState is ChatLoaded) {
                      final newMessages = chatState.messages
                          .where((msg) =>
                      !messages.any((m) => m.text == msg.text))
                          .map((msg) =>
                          Message(
                              msg.text,
                              false,
                              DateFormat("hh:mm a")
                                  .format(DateTime.now()),
                              isImage: msg.isImage))
                          .toList();
                      setState(() {
                        messages.addAll(newMessages);
                      });
                    } else if (chatState is ChatError) {
                      return Center(child: Text('Error: ${chatState.error}'));
                    }
                    return MessagesList(
                      messages: messages,
                      scrollController: _scrollController,
                      messageKeys: _messageKeys,
                      onLongPress: _handleLongPress,
                      onDoubleTap: _handleDoubleTap,
                    );
                  },
                ),
              ),
            ),
            MessageInput(
              messageController: messageController,
              onSendPressed: () => _sendMessage(context),
              onAttachFilePressed: () => _pickFile(context),
              onImagePressed: () => _pickImage(context),
              onEmojiPickerPressed: () => _showEmojiPicker(context, -1),
              onVoiceMessageClosed: (cancelled) => _stopVoiceRecording(context , cancelled: cancelled),
              onVoiceMessageStarted: () => _startVoiceRecording(context),
              isRecording: Provider.of<VoiceMessageProvider>(context).isRecording,
            ),
          ],
        ),
      ),
    );
  }
}