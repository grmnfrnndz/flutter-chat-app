import 'package:flutter/material.dart';


class BotonAzul extends StatelessWidget {

  final void Function() onPressed;
  final String texto;

  const BotonAzul({Key? key, 
    required this.onPressed, 
    required this.texto}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child:  ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(2),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            shape:  MaterialStateProperty.all<StadiumBorder>(StadiumBorder())

          ),
          child: Container(
            width: double.infinity,
            height: 55,
            child: Center(
              child: Text(texto, style: TextStyle(color: Colors.white, fontSize: 18),)))),
    );
  }
}