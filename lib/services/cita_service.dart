import 'dart:convert';

import 'package:appx/global/environment.dart';
import 'package:appx/models/cita_response.dart';
import 'package:appx/models/citas_medico_response.dart';
// import 'package:appx/models/cita.dart';
import 'package:appx/models/citas_response.dart';
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

    var request = http.Request('POST', Uri.parse('${Environment.apiUrl}/cita'));
    request.body = jsonEncode(data);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    this.autenticando = false;

    if (response.statusCode == 200) {
      final citaResponse =
          citasResponseFromJson(await response.stream.bytesToString());

      this.cita = citaResponse.citas as Cita;

      return true;
    } else {
      return false;
    }
  }

  Future<List<Cita>> getCitasPaciente(String tipo) async {
    final resp = await http.get('${Environment.apiUrl}/cita/$tipo', headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken()
    });
    final citasResp = citasResponseFromJson(resp.body);

    return citasResp.citas;
  }

  Future<List<MedicoCita>> getCitasMedico(String tipo, String estado) async {
    final resp = await http.get(
        '${Environment.apiUrl}/cita/medicocitasolicitud/$tipo/$estado',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });
    //print(resp.body);
    final citasResp = medicoCitasResponseFromJson(resp.body);

    return citasResp.medicoCitas;
  }

  Future<bool> setAceptaMedicoCita(String citaId) async {
    final resp = await http.get(
        '${Environment.apiUrl}/cita/medico/$citaId',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });
    var arrbody = jsonDecode(resp.body);

    return arrbody['ok'] ? true : false;
  }
}
