import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
// import 'package:frontend/screens/welcome_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/components/message_bubble.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart';

class ChatScreen extends StatefulWidget {
  static const String id = '/chat';
  List<MessageBubble> messageBubbles = [];
  final WebSocketChannel channel =
      HtmlWebSocketChannel.connect('ws://127.0.0.1:8080/ws/chat/room/');
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final getUsername = 'http://127.0.0.1:8080/chat/getUser/';
  final signoutURL = 'http://127.0.0.1:8000/chat/signout/';
  final messageTextController = TextEditingController();

  String messageText;
  String username;
  List<MessageBubble> messageBubbles = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      var response = await http.get(getUsername);
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        username = responseBody['username'];
      } else {
        throw Exception(responseBody['msg']);
      }
      // username = 'admin';
    } catch (e) {
      Navigator.pop(context);
    }
  }

  void sendMessage(String messageText) {
    if (messageTextController.text.isNotEmpty) {
      var msg = jsonEncode({
        'message': messageText,
        'username': username,
      });
      widget.channel.sink.add(msg);
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(ChatScreen oldWidget) {
    if (messageBubbles != widget.messageBubbles) {
      setState(() {
        messageBubbles = widget.messageBubbles;
      });
      super.didUpdateWidget(oldWidget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              http.get(signoutURL);
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Expanded(
            //   child: ListView(
            //     reverse: true,
            //     padding: EdgeInsets.symmetric(
            //       horizontal: 10.0,
            //       vertical: 20.0,
            //     ),
            //     children: <MessageBubble>[],
            //   ),
            // ),
            StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final message = jsonDecode(snapshot.data);
                    messageBubbles.insert(
                        0,
                        MessageBubble(
                          sender: message['username'],
                          isMe: message['username'] == username,
                          text: message['message'],
                        ));
                  }

                  return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messageBubbles.length,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 20.0,
                      ),
                      itemBuilder: (context, index) {
                        return messageBubbles[index];
                      },
                    ),
                  );
                }),

            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      sendMessage(messageText);
                      messageTextController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
