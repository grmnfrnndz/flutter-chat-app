import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_app_01/src/globals/environments.dart';
import 'package:chat_app_01/src/models/models.dart';

class AuthService with ChangeNotifier {

  late Usuario usuario;
  bool _autenticando = false;
  bool _registrando = false;
  
  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;

  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  bool get registrando => this._registrando;

  set registrando(bool valor) {
    this._registrando = valor;
    // notifyListeners();
  }


  // getter y setter del token de forma estática
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token!;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {

    this.autenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    final response = await http.post(
      Uri.parse('${Environments.apiUrl}/login'), 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    this.autenticando = false;

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      this.usuario = loginResponse.usuario;

      // TODO: guardar token en lugar seguro
      await _guardarToken(loginResponse.token);
      
      return true;
    } else {

      return false;

    }

  }


  Future register(String email, String password, String nombre) async {

    this.registrando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };

    final response = await http.post(
      Uri.parse('${Environments.apiUrl}/login/new'), 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    this.registrando = false;

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      this.usuario = loginResponse.usuario;

      // TODO: guardar token en lugar seguro
      await _guardarToken(loginResponse.token);
      
      return true;
    } else {

      final resp = json.decode(response.body);
      
      return resp['msg'];

    }

  }

  Future isLoggedin() async {
    final token = await _storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('${Environments.apiUrl}/login/renew'), 
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? 'no valido'
      }
    );

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      this.usuario = loginResponse.usuario;

      // TODO: guardar token en lugar seguro
      await _guardarToken(loginResponse.token);
      
      return true;
    } else {

      logout();
      return false;

    }

  }




  Future _guardarToken(String token) async {
    // guardar el token
    await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    // borrar el token
    return await _storage.delete(key: 'token');
  }



}