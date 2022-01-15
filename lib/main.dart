import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app_01/src/routes/routes.dart';
import 'package:chat_app_01/src/services/services.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (BuildContext context) => AuthService(),)
    ],
    child: MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'loading',
      routes: appRoutes,
    );
  }
}