import 'package:fitcpxaluno/src/services/chat_service.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_chat/chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> _messages = [];
  final chatService = ChatService();

  String _currentUserId = 'user-1';

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final stundetId = prefs.getInt('id_client');

    final response = await chatService.getMessages();
    setState(() {
      _messages = response;
      _currentUserId = "student-${stundetId.toString()}";
    });
  }

  void _sendMessage(String text) {
    chatService.sendMessage(text, context);
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          time: DateTime.now(),
          author: ChatAuthor(id: _currentUserId, name: 'Você'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Chat')),
      color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
      child: Padding(
        padding: EdgeInsetsGeometry.only(bottom: 40, left: 15, right: 15),
        child: SfChat(
          messages: _messages,
          outgoingUser: _currentUserId,
          composer: ChatComposer(
            textStyle: TextStyle(
              color: CupertinoColors.label.resolveFrom(context),
            ),
            decoration: InputDecoration(
              hintText: 'Digite uma mensagem…', // adaptado para PT-BR
              hintStyle: TextStyle(
                color: CupertinoColors.label.resolveFrom(context),
              ),
            ),
          ),
          actionButton: ChatActionButton(
            child: Icon(
              CupertinoIcons.paperplane_fill,
              color: CupertinoColors.label.resolveFrom(context),
              size: 20,
            ),
            onPressed: (String newMessage) {
              if (newMessage.trim().isNotEmpty) {
                _sendMessage(newMessage);
              }
            },
          ),
        ),
      ),
    );
  }
}
