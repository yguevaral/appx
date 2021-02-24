import 'dart:convert';
import 'dart:io';

import 'package:appx/global/environment.dart';
import 'package:appx/models/usuario.dart';
import 'package:appx/models/usuarios_response.dart';
import 'package:appx/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  final _storage = new FlutterSecureStorage();

  Future<List<Usuario>> getUsuarios() async {
    try {
      final resp = await http.get('${Environment.apiUrl}/usuarios', headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }

  Future<bool> setUsuarioTokenApp(String tokenApp) async {
    try {
      final tokenUsuario = await this._storage.read(key: 'token');

      final data = {
        'token': tokenApp,
        'plataforma': Platform.isAndroid ? "A" : "I"
      };

      var headers = {
        'Content-Type': 'application/json',
        'x-token': tokenUsuario
      };
      var request = http.Request(
          'POST', Uri.parse('${Environment.apiUrl}/usuarios/appToken'));
      request.body = jsonEncode(data);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      // final strRespuesta = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
