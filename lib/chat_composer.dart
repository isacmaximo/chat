//barra de envio do chat

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TextComposer extends StatefulWidget {

  //função de enviar a mensagem
  TextComposer(this.sendMessage);
  final Function({String text, File imgFile}) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  //controlador do textfield do campo de mensagem:
  final TextEditingController _controller = TextEditingController();

  //vai indicar se eu estou compondo um texto ou não
  bool _isComposing = false;

  //função que reseta o campo (input) e o botão de enviar
  void _reset(){
    //apaga o campo depois de enviar a mensagem
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

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
            onPressed: () async{
              //pegando a imagem da câmera
              final File imgFile = await ImagePicker.pickImage(source: ImageSource.camera);
              //se não tirar foto:
              if (imgFile == null){
                return;
              }
              //enviando a foto
              widget.sendMessage(imgFile: imgFile);

            },
          ),

          //campo de texto
          //como queremos que ele aproveite o melhor espaço possível, utilizamos o expanded
          //quando colocamos collapsed, fica melhor o aproveitamento do input nesse caso
          //onChanged é para quando há qualquer alteração no textfierld
          //onSubimited é para quando formos enviar a mensagem
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(hintText: "Enviar uma Mensagem"),
              onChanged: (text){
                setState(() {
                  //se estiver digitando na barra,vai indicar que o há alguma alteração (composing)
                  _isComposing = text.isNotEmpty;

                });
              },
              onSubmitted: (text){
                //pega a mensagem e e armazena na função para enviar a mensagem
                widget.sendMessage(text : text);
                _reset();

              },
            ),
          ),

          //botão de enviar a mensagem
          IconButton(
            icon: Icon(Icons.send),
            //aqui vai averiguar se algo foi digitado no textfield, se não o botão não é habilitado
            onPressed: _isComposing ? (){
              //chama a função de enviar mensagem pegando do controlador do textfield
              widget.sendMessage(text: _controller.text);
              _reset();
            } : null,
          )
        ],
      ),
    );
  }
}
