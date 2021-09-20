
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  //recebe os dados os dados
  ChatMessage(this.data, this.mine);

  final Map<String, dynamic> data;
  //para saber se sou eu ou não(se for eu digitando as mensagens vão ficar de um lado, se não as mensagens vão ficar do outro lado)
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      //margem para que  a mensagem não fique colada
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: <Widget>[
          //se a mensagem não for minha, é exibida com essas configurações (lado esquerdo)
          ! mine ?
          Padding(padding: const EdgeInsets.only(right: 16),
            //imagem circular do usuário:
          child: CircleAvatar(
            backgroundImage: NetworkImage(data["senderPhotoUrl"]),
            ),

            //se a mensagem não for minha:
          ) : Container(),

          Expanded(
            child: Column(
              //se for minha mensagem fica de um lado, se for a mensagem de outro, fica de outro lado
              crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                data["imgUrl"] != null ?

                Image.network(data["imgUrl"], width: 250,) :

                Text(
                  data["text"],
                  textAlign: mine ? TextAlign.end : TextAlign.start,
                  style: TextStyle(fontSize: 16,),),

                //nome do usuário:
                Text(data["senderName"], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),

              ],
            ),
          ),

          //se a mensagem for minha (lado direito)
          mine ?
          Padding(padding: const EdgeInsets.only(left: 16),
            //imagem circular do usuário:
            child: CircleAvatar(
              backgroundImage: NetworkImage(data["senderPhotoUrl"]),
            ),

          ) : Container(),

        ]
      ),
    );
  }
}
