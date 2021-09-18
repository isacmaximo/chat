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
//collection: acessa a aba coleção (db)
//document: acessa a aba documentos (db)
//setData: você diz qual dado deve ser colocado (bd)
//quando colocamos nada dentro dos parênteses o db gera um id único


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main(){


  runApp(MaterialApp(
    home: HomePage(),
  ));
  Firestore.instance.collection("col").document("doc").setData({"texto":"isac"});
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
