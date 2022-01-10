import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app_01/src/widgets/widgets.dart';


class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;

  List<ChatMessage> _messages = [
      // ChatMessage(texto: 'Hola Germán dsadada dadadasdasdada asdasdadasda sdasdasdadasd sdadasadsdas', uid: '123'),
      // ChatMessage(texto: 'Hola Germán', uid: '123'),
      // ChatMessage(texto: 'Hola Germán', uid: '123'),
      // ChatMessage(texto: 'Hola Germán', uid: '123'),
      // ChatMessage(texto: 'Hola Germán', uid: '123'),
      // ChatMessage(texto: 'Hola Germán', uid: '123'),
      // ChatMessage(texto: 'Hola Germán', uid: '1123'),
      // ChatMessage(texto: 'Hola Germán', uid: '1123'),
      // ChatMessage(texto: 'Hola Germán', uid: '1123'),
      // ChatMessage(texto: 'Hola Germán', uid: '1123'),
      // ChatMessage(texto: 'Hola Germán', uid: '1123'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Column(
            children: [
              CircleAvatar(
                child: Text('Te', style: TextStyle(fontSize: 12),),
                backgroundColor: Colors.blueAccent,
                maxRadius: 14,
              ),
              SizedBox(height: 3),
              Text('Melissa Flores', style: TextStyle(color: Colors.black87, fontSize: 12))
            ],
          ),
        ),
        centerTitle: true,
        elevation: 1,
      ),

      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) => _messages[index])
              ),
              Divider(height: 1,),

              Container(
                color: Colors.white,
                height: 40,
                child: _input_chat(),
              )
          ],
        )
     ),
   );
  }

  Widget _input_chat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto) {
                  // TODO: cuando hay un valor, para poder postear
                  setState(() {
                    if (texto.trim().length > 0) {
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(hintText: 'Enviar Mensaje'),
                focusNode: _focusNode,
              )
            ),

            // boton de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS ?
              CupertinoButton(
                child: Text('Enviar'), 
                onPressed: () {}) :
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: IconTheme(
                  data: IconThemeData(
                    color: Colors.blue[400]
                  ),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed:  (_estaEscribiendo) ? () =>_handleSubmit(_textController.text.trim()) : null, 
                    icon: Icon(Icons.send, color: Colors.blue[400])),
                ),
              )
            )

          ],),
      ),
    );
  }

  void _handleSubmit(String texto) {
      print(texto);

      if (texto.trim().length == 0) return;

      final message = ChatMessage(uid: '1233', texto: texto, 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400))
      );

      _messages.insert(0, message);
      message.animationController.forward();

      setState(() {
        _estaEscribiendo = false;
        _focusNode.requestFocus();
      _textController.clear();
      });
  }

  @override
  void dispose() {
    // TODO: limpiar socket


    for (ChatMessage message in _messages){
      message.animationController.dispose();
    }

    super.dispose();
  }


}