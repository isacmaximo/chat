//tela do chat

import 'package:chat/chat_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  //função de enviar a mensagem para o firestore
  void _sendMessage(String text){
    //seria o mesmo que usar: Firestore.instance.collection("x").document().setData({a : b});
    //Firebase > Coleção(mensagens) > adiciona_documento() > "texto" que recebe "texto digitado"
    Firestore.instance.collection("messages").add({
      "text" : text
    });
  }

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
      //aqui vai pegar o TextComposer vai pegar a função de enviar a mensagem e enviar para o firebase
      body: TextComposer(_sendMessage),
    );
  }
}
