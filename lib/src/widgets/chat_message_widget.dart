import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({Key? key, 
    required this.texto, 
    required this.uid, 
    required this.animationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
        child: Container(
          child: (uid == '123') ?
          _my_message() :
          _not_my_message()
        ),
      ),
    );
  }

  Widget _my_message() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 5, left: 50, right: 5),
        child: Text(texto, style: TextStyle(color: Colors.white)),
        decoration: BoxDecoration(
          color: Color(0xff3d9ef6),
          borderRadius: BorderRadius.circular(15)
        ),
      ));
  }

  Widget _not_my_message() {
     return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 5, left: 5, right: 50),
        child: Text(texto, style: TextStyle(color: Colors.black87)),
        decoration: BoxDecoration(
          color: Color(0xffe4e5e8),
          borderRadius: BorderRadius.circular(15)
        ),
      ));
  }

}