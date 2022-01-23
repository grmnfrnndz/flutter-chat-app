import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app_01/src/models/models.dart';
import 'package:chat_app_01/src/services/services.dart';

class UsuarioPage extends StatefulWidget {

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {

  final usuarioService = UsuariosService();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  // final usuarios = [
  //   Usuario(uid: '1', nombre: 'María', email: 'maria@gmail.com', online: true),
  //   Usuario(uid: '2', nombre: 'Germán', email: 'german@gmail.com', online: false),
  //   Usuario(uid: '3', nombre: 'Andrés', email: 'andres@gmail.com', online: true),
  // ];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }  


  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('${usuario.nombre}')),
        elevation: 1,
        backgroundColor: Colors.blue,
        leading: IconButton(onPressed: () {
          socketService.disconnect();
          AuthService.deleteToken();
          Navigator.pushReplacementNamed(context, 'login');
        }, 
        icon: Icon(Icons.exit_to_app)),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (ServerStatus.Online == socketService.serverStatus ) ? Icon(Icons.check_circle_outline, color: Colors.blue[400])
            : Icon(Icons.offline_bolt, color: Colors.red)
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400]!,
        ),
        child: _listViewUsuarios()
      ),
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: (BuildContext context, index) => Divider(), 
      itemBuilder: (BuildContext context, index) => _usuarioListTile(usuarios[index]), 
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          child: Text(usuario.nombre.substring(0, 2)
          ),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: (usuario.online) ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: () {
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.usuarioPara = usuario;
          Navigator.pushNamed(context, 'chat');
        },
      );
  }

  _cargarUsuarios() async {
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    this.usuarios = await usuarioService.getUsuarios();
    setState(() {});
    _refreshController.refreshCompleted();
  }


}