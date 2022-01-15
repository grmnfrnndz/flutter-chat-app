import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


mostrarAlerta(BuildContext context, String titulo, String subtitulo) {

  if(Platform.isAndroid) {
    return showDialog(context: context, 
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ok'),
            elevation: 5,
            textColor: Colors.blue,
          )
        ]
      ));
  }

  showCupertinoDialog(context: context, 
  builder: (_) => CupertinoAlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text('Ok'),
            isDefaultAction: true,
          )
        ]
      ));
  

}
