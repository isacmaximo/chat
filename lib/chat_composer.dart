//barra de envio do chat

import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  //vai indicar se eu estou compondo um texto ou não
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    //barra de envio de mensagens, fotos, etc,  do chat
    return Container(
      //uma margem melhora o aspecto desses widgets
      margin: const EdgeInsets.symmetric( horizontal: 8),
      child: Row(
        children: <Widget>[

          //ícone da câmera
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: (){},
          ),

          //campo de texto
          //como queremos que ele aproveite o melhor espaço possível, utilizamos o expanded
          //quando colocamos collapsed, fica melhor o aproveitamento do input nesse caso
          //onChanged é para quando há qualquer alteração no textfierld
          //onSubimited é para quando formos enviar a mensagem
          Expanded(
            child: TextField(
              decoration: InputDecoration.collapsed(hintText: "Enviar uma Mensagem"),
              onChanged: (text){
                setState(() {
                  //se estiver digitando na barra,vai indicar que o há alguma alteração (composing)
                  _isComposing = text.isNotEmpty;

                });
              },
              onSubmitted: (text){},
            ),
          ),

          //botão de enviar a mensagem
          IconButton(
            icon: Icon(Icons.send),
            //aqui vai averiguar se algo foi digitado no textfield, se não o botão não é habilitado
            onPressed: _isComposing ? (){} : null,
          )
        ],
      ),
    );
  }
}