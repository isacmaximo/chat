//Chat com Firebase

//plugins necessários:
//cloud_firestore: ^0.13.0+1
//image_picker: ^0.6.2+3
//google_sign_in: ^4.1.1
//firebase_storage: ^3.1.1
//firebase_auth: ^0.15.3

//olhe as configurações dos build gradle, settings gradle, e android manifest
//além disso tem que ter o google services json

//Firestore: você acessa o firestore (bd)
//instance: você acessa em qualquer lugar com uma única instância
//collection: acessa a aba coleção primária, quando está no final acessa uma subcategoria (db)
//document: acessa a aba documentos (db)
//setData: você diz qual dado deve ser colocado (bd)
//updateData: podemos informar apenas o campo que queremos modificar (bd)
//quando colocamos nada dentro dos parênteses o db gera um id único

//para que possamos ler algo que está no banco de dados, utilizamos QuerySnapshot
//por exemplo: QuerySnapshot snapshot = await Firesote.instance.collection().get...()snapshot...forEach
//forEach: quer dizer para cada um desses elementos


import 'package:chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main(){


  runApp(MaterialApp(
    title: "Chat Flutter",
    //não mostrar a tarja vermelha de debug
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      iconTheme: IconThemeData(
        color: Colors.blue
      )
    ),
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ChatScreen();
  }
}
