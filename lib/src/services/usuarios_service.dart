import 'package:chat_app_01/src/globals/environments.dart';
import 'package:chat_app_01/src/services/services.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app_01/src/models/models.dart';

class UsuariosService {



  Future<List<Usuario>> getUsuarios() async {

    try {


      final resp = await http.get(
        Uri.parse('${Environments.apiUrl}/usuarios/'), 
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );

      final usuarioResponse = usuariosResponseFromJson(resp.body);

      return usuarioResponse.usuarios;
    } catch (e) {
      return [];
    }

  }



}