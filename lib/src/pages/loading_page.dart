import 'package:chat_app_01/src/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_01/src/services/services.dart';

class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    

    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center(
              child: Text('Espere...'),
          );
        },
      ),
   );
  }



  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final autenticado =  await authService.isLoggedin();

    if (autenticado) {
      // TODO: Conectar al socket
      // Navigator.pushReplacementNamed(context, 'usuarios');

      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => UsuarioPage(),
        transitionDuration: Duration(milliseconds: 0)
        )
      );



    } else {
      // Navigator.pushReplacementNamed(context, 'login');

      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => LoginPage(),
        transitionDuration: Duration(milliseconds: 0)
        )
      );

    }

  }


}