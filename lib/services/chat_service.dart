import 'package:appx/global/environment.dart';
import 'package:appx/models/mensajes_response.dart';
import 'package:appx/models/usuario.dart';
import 'package:appx/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioID) async {
    final resp = await http.get('${Environment.apiUrl}/mensajes/$usuarioID',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });
    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;
  }
}
