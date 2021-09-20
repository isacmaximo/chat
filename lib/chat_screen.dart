//tela do chat

import 'dart:io';

import 'package:chat/chat_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'chat_message.dart';


class ChatScreen extends StatefulWidget {

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{

  //configuração inicial de login com o google:
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //snackbar (barra de informação)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //variável que posteriormaente vai receber o usuário atual.
  //se não logar currentUser continua nulo
  FirebaseUser _currentUser;

  //variável que irá indicar se está carregando a imagem ou não:
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //verificar se está logado
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      setState(() {
        _currentUser = user;
      });

    });

  }

  Future<FirebaseUser> _getUser() async{

    //se já estiver logado:
    if (_currentUser != null){
      return _currentUser;
    }

    //se não estiver logado:
    try{
      //login google:
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      //contém tokens necessários para fazer a conexão com op firebase:
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      //para se relacionar com o firebase:
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken
      );

      //login em sí:
      final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential);

      //pegando o usuário:
      final FirebaseUser user = authResult.user;

      return user;

    }
    //se ocorrer algum erro:
    catch(error){
    return null;
    }
  }

  //função de enviar a mensagem para o firestore
  //colocando entre chaves pois os parâmetros são opicionais
  void _sendMessage({String text, File imgFile}) async{

    //vai esperar a resposta (se está logado ou não)
    final FirebaseUser user = await _getUser();

    if (user == null){
      //snackbar e seu conteúdo ao receber usuário nulo
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Não foi possível fazer o login. Tente Novamente!"),
        backgroundColor: Colors.red,
        ),

      );
    }

    //se o login der certo, então as informações serão aramazenadas nesse mapa:
    Map<String, dynamic> data = {
      "uid" : user.uid,
      "senderName" : user.displayName,
      "senderPhotoUrl" : user.photoUrl,
      "time" : Timestamp.now(),

    };

    //enviando um arquivo para o Firebase storage:
    if(imgFile != null){
      StorageUploadTask task = FirebaseStorage.instance.ref().child(
        //a imagem vai ser identificada pelo id do usuário junto com o tempo em microssegundo do momento
          user.uid + DateTime.now().microsecondsSinceEpoch.toString()).putFile(imgFile);

      //idica que a imagem está sendo carregada
      setState(() {
        _isLoading = true;
      });

      //retorna as informações da task concluída:
      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url= await taskSnapshot.ref.getDownloadURL();
      data["imgUrl"] = url;

      //indica que a imagem carregou
      setState(() {
        _isLoading = false;
      });

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
      //chave do scaffold que vai mostar se o login deu certo ou não
      key: _scaffoldKey,
      //barra que fica no topo
      appBar: AppBar(
        title: Text(
          //título do chat (se for diferente de nulo aparece o nome do usuário)
          _currentUser != null ? "${_currentUser.displayName}" : "Chat App",
        ),
        centerTitle: true,
        elevation: 0,

        //botão de logout e sua função:
        actions: <Widget>[
          _currentUser != null ? IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              FirebaseAuth.instance.signOut();
              googleSignIn.signOut();
              //mensagem de saída:
              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Você saiu com sucesso!"),));

            }
          ) : Container()
        ],

      ),

      //corpo da tela de chat

      body: Column(
        children: <Widget>[

          //aqui vão aparecer os textos e imagens enviadas com o listview:
          Expanded(
            //retorna o conteúdo do chat em tempo real com o StreamBuilder
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("messages").orderBy("time").snapshots(),
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
                    List<DocumentSnapshot> documents = snapshot.data.documents.reversed.toList();

                    return ListView.builder(
                      //quantos documetos foram recebidos em "messages"
                      itemCount: documents.length,
                      //para aparecer as mensagens de baixo para cima
                      reverse: true,
                      itemBuilder: (context, index){
                        //retornar a data (mensagens, imagens e outras informações do chat)
                        return ChatMessage(documents[index].data,
                        documents[index].data["uid"] == _currentUser?.uid
                        );
                      },

                    );
                }
              }
            ),
          ),

          //animação carregando foto (upload)
          _isLoading ? LinearProgressIndicator() : Container(),

          //aqui vai pegar o TextComposer vai pegar a função de enviar a mensagem/imagem  e enviar para o Firebase
          TextComposer(_sendMessage),
        ],
      )

    );
  }
}
