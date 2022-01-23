import 'dart:io';

import 'package:chat_app_01/src/models/models.dart';
import 'package:chat_app_01/src/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app_01/src/widgets/widgets.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

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
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);


    this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(chatService.usuarioPara.uid);

  }

  void _cargarHistorial(String usuarioId) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioId);

    final history = chat.map((m) => new ChatMessage(
      texto: m.mensaje,
      uid: m.de,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400))..forward()
    ) );

    setState(() {
      _messages.insertAll(0, history);
    });

  }

  void _escucharMensaje (dynamic payload) {
    ChatMessage message = ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400))
    );

    _messages.insert(0, message);
    message.animationController.forward();
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {

    final usuario = this.chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(usuario.nombre.substring(0, 2), style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blueAccent,
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(usuario.nombre, style: TextStyle(color: Colors.black87, fontSize: 12))
          ],
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
      // print(texto);

      if (texto.trim().length == 0) return;

      final message = ChatMessage(
        uid: this.authService.usuario.uid, 
        texto: texto, 
        animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400))
      );

      _messages.insert(0, message);
      message.animationController.forward();

      setState(() {
        _estaEscribiendo = false;
        _focusNode.requestFocus();
      _textController.clear();
      });

      // TODO: en la data se debe cambiar el para por obtenido del usuario para
      // solo para prueba se esta utilizando el mismo usuario
      this.socketService.emit('mensaje-personal', {
        'de': this.authService.usuario.uid,
        'para': this.chatService.usuarioPara.uid,
        // 'para': this.authService.usuario.uid,
        'mensaje': texto,
      });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages){
      message.animationController.dispose();
    }

    this.socketService.socket.off('mensaje-personal');

    super.dispose();
  }


}