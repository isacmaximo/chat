//tela do chat

import 'package:chat/chat_composer.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    //tela do chat:
    return Scaffold(
      //barra que fica no topo
      appBar: AppBar(
        title: Text("Olá"),
        elevation: 0,
      ),

      //corpo da tela de chat
      body: TextComposer(),
    );
  }
}
