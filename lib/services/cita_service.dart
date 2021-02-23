import 'dart:convert';

import 'package:appx/global/environment.dart';
import 'package:appx/models/cita_response.dart';
import 'package:appx/models/cita.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_service.dart';

class CitaService with ChangeNotifier {
  Cita cita;
  bool _autenticando = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estatica

  Future<bool> crearCita(String sitomas, String tipo) async {
    this.autenticando = true;

    final data = {'sintomas': sitomas, 'tipo': tipo};

    var headers = {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken()
    };

    var request =
        http.Request('POST', Uri.parse('${Environment.apiUrl}/cita'));
    request.body = jsonEncode(data);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    this.autenticando = false;

    if (response.statusCode == 200) {
      final citaResponse =
          citaResponseFromJson(await response.stream.bytesToString());

      this.cita = citaResponse.cita;

      return true;
    } else {
      return false;
    }
  }


}