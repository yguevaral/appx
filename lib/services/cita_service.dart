import 'dart:convert';

import 'package:appx/global/environment.dart';
import 'package:appx/models/citas_medico_response.dart';
import 'package:appx/models/citas_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class CitaService with ChangeNotifier {
  Cita cita;
  bool _autenticando = false;


  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estatica

  Future<bool> crearCita(String sitomas, String tipo) async {
    this.autenticando = true;

    try {
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

      // print('!!!!!!!!!!!!!!!!!!!!!!!!!!1');
      // print(response.statusCode);
      if (response.statusCode == 200) {
        // var str = await response.stream.bytesToString();
        // print(str);
        // final citaResponse = citasResponseFromJson(str);

        // this.cita = citaResponse.citas as Cita;

        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
      print(e);
      // print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
      return false;
    }
  }

  Future<List<Cita>> getCitasPaciente(String tipo) async {
    this.autenticando = true;

    final resp = await http.get('${Environment.apiUrl}/cita/$tipo', headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken()
    });
    final citasResp = citasResponseFromJson(resp.body);
    this.autenticando = false;

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
    final resp = await http.get('${Environment.apiUrl}/cita/medico/$citaId',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });
    var arrbody = jsonDecode(resp.body);

    return arrbody['ok'] ? true : false;
  }

  Future<bool> setRechazaMedicoCita(String citaId) async {
    this.autenticando = true;

    final resp = await http.get('${Environment.apiUrl}/cita/medicoRechazo/$citaId',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });
    var arrbody = jsonDecode(resp.body);
    this.autenticando = false;

    return arrbody['ok'] ? true : false;
  }

  Future<bool> setFinalizaMedicoCita(String citaId) async {
    this.autenticando = true;

    final resp = await http.get('${Environment.apiUrl}/cita/medicoFinaliza/$citaId',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });
    var arrbody = jsonDecode(resp.body);
    this.autenticando = false;


    return arrbody['ok'] ? true : false;
  }

}
