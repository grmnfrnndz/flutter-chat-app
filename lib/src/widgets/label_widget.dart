import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String ruta;
  final String titulo;
  final String subtitulo;

  const Labels({Key? key, required this.ruta, required this.titulo, required this.subtitulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(titulo, style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w300)),
          SizedBox(height: 10,),
          GestureDetector(
            child: Text(subtitulo, style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pushReplacementNamed(context, ruta);
            },
            ),
        ]
      )
    );
  }
}