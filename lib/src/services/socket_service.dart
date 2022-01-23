import 'package:chat_app_01/src/globals/environments.dart';
import 'package:chat_app_01/src/services/services.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;


  // SocketService(){
  //   this._initConfig();
  // }

  void connect() async {
    
    final token = await AuthService.getToken();

    // Dart client
    this._socket = IO.io(Environments.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true, // forzar una nueva
      'extraHeaders': {
        'x-token': token
      }
    });

    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

  }

  void disconnect() {
    if (this._socket != null) {
      this._socket.disconnect();
    }
  }

}