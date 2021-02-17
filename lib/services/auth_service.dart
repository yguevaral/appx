import 'dart:convert';

import 'package:appx/global/environment.dart';
import 'package:appx/models/login_response.dart';
import 'package:appx/models/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  Usuario usuario;
  bool _autenticando = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estatica
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {'email': email, 'password': password};

    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('${Environment.apiUrl}/login'));
    request.body = jsonEncode(data);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    this.autenticando = false;

    if (response.statusCode == 200) {
      final loginResponse =
          loginResponseFromJson(await response.stream.bytesToString());
      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);
      // guardar datos del token

      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    this.autenticando = true;

    final data = {'email': email, 'password': password, 'nombre': nombre};

    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('${Environment.apiUrl}/login/new'));
    request.body = jsonEncode(data);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final strRespuesta = await response.stream.bytesToString();
    this.autenticando = false;

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(strRespuesta);

      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      final resBody = jsonDecode(strRespuesta);

      return resBody['msg'] != null
          ? resBody['msg']
          : "Ingrese todos los datos correctamente";
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');

    final resp = await http
        .get('${Environment.apiUrl}/login/renew', headers: {'x-token': token});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);

      return true;
    }
    else{
      this._logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _logout() async {
    await _storage.delete(key: 'token');
  }
}
