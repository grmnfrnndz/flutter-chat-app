import 'package:flutter/material.dart';

import 'package:chat_app_01/src/pages/pages.dart';

final  Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': ( _ ) => UsuarioPage(),
  'chat': ( _ ) => ChatPage(),
  'login': ( _ ) => LoginPage(),
  'register': ( _ ) => RegisterPage(),
  'loading': ( _ ) => LoadingPage(),
};
