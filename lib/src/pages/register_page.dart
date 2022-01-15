import 'package:chat_app_01/src/helpers/mostrar_alerta.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_01/src/widgets/widgets.dart';
import 'package:chat_app_01/src/services/services.dart';


class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(imageRuta: 'assets/tag-logo.png', textoImagen: 'Messenger2',),
                _Form(),
                Labels(ruta: 'login', titulo: '¿Ya tienes una Cuenta?', subtitulo: 'Ingresa Ahora'),
                Text('Términos y condiciones de uso.', style: TextStyle(fontWeight: FontWeight.w200),)
              ],
            ),
          ),
        ),
      )
   );
  }
}



class _Form extends StatefulWidget {

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [


          CustomInput(icon: Icons.supervised_user_circle,
            placeHolder: 'Nombre',
            textController: nombreCtrl,
          ),

          CustomInput(icon: Icons.email_outlined,
            placeHolder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),

          CustomInput(icon: Icons.lock_outlined,
            placeHolder: 'Contraseña',
            textController: passwordCtrl,
            isPassword: true,
          ),

          // TODO: crear boton
         BotonAzul(
           texto: authService.registrando ? 'Procesando...' :'Registrar',
           onPressed: authService.registrando ? () {} : () async {
           
              // oculta el teclado luego oprimir el boton
             FocusScope.of(context).unfocus();

              final registerOk = await authService.register(emailCtrl.text.trim(), passwordCtrl.text.trim(), nombreCtrl.text.trim());

              if ( registerOk  == true) {
                // TODO: conectar al socket server
                
                mostrarAlerta(context, 'Registro Completado', 'Registro creado correctamente.');
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                // Mostrar una alerta
                mostrarAlerta(context, 'Login Incorrecto', registerOk);
              }

           }, )
        ],
      ),
    );
  }
}


