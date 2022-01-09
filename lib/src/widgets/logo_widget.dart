import 'package:flutter/material.dart';


class Logo extends StatelessWidget {

  final String imageRuta;
  final String textoImagen;

  const Logo({Key? key, 
    required this.imageRuta, 
    required this.textoImagen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        width: 170,
        child: Column(
          children: [
            Image(image: AssetImage(imageRuta)),
            SizedBox(height: 20,),
            Text(textoImagen, style: TextStyle(fontSize: 30),)
          ],
        ),
      ),
    );
  }
}