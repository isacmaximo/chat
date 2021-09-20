//tela do chat

import 'dart:io';

import 'package:chat/chat_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{

  //função de enviar a mensagem para o firestore
  //colocando entre chaves pois os parâmetros são opicionais
  void _sendMessage({String text, File imgFile}) async{

    Map<String, dynamic> data = {};

    //enviando um arquivo para o Firebase storage:
    if(imgFile != null){
      StorageUploadTask task = FirebaseStorage.instance.ref().child(DateTime.now().microsecondsSinceEpoch.toString()).putFile(imgFile);
      //retorna as informações da task concluída:
      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url= await taskSnapshot.ref.getDownloadURL();
      data["imgUrl"] = url;
    }

    //enviando o texto (mensagem)  para o Firebase
    if(text != null){
      data["text"] = text;
    }

    //seria o mesmo que usar: Firestore.instance.collection("x").document().setData({a : b});
    //Firebase > Coleção(mensagens) > adiciona_documento() > "texto" que recebe "texto digitado"
    //aqui vai enviar o que estiver no map data, podendo ser a imagem, mensagem
    Firestore.instance.collection("messages").add(data);
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

      body: Column(
        children: <Widget>[

          //aqui vão aparecer os textos e imagens enviadas com o listview:
          Expanded(
            //retorna o conteúdo do chat em tempo real com o StreamBuilder
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("messages").snapshots(),
              builder: (context, snapshot) {
                switch(snapshot.connectionState){
                  //caso a conexão retorne nada:
                  case ConnectionState.none:
                    //caso esteja esperando:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),


                    );
                  default:
                    List<DocumentSnapshot> documents = snapshot.data.documents;

                    return ListView.builder(
                      //quantos documetos foram recebidos em "messages"
                      itemCount: documents.length,
                      //para aparecer as mensagens de baixo para cima
                      reverse: true,
                      itemBuilder: (context, index){
                        return ListTile(
                          title: Text(documents[index].data["text"]),
                        );
                      },

                    );
                }
              }
            ),
          ),

          //aqui vai pegar o TextComposer vai pegar a função de enviar a mensagem/imagem  e enviar para o Firebase
          TextComposer(_sendMessage),
        ],
      )

    );
  }
}
