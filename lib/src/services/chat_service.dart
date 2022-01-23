import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app_01/src/globals/environments.dart';
import 'package:chat_app_01/src/services/services.dart';
import 'package:chat_app_01/src/models/models.dart';

class ChatService with ChangeNotifier {

  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat (String usuarioId) async {
    try {


      final resp = await http.get(
        Uri.parse('${Environments.apiUrl}/mensajes/$usuarioId'), 
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );

      final mensajesResponse = mensajesResponseFromJson(resp.body);

      return mensajesResponse.mensajes;
    } catch (e) {

      return [];

    }


  }


}


