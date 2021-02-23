// To parse this JSON data, do
//
//     final citaResponse = citaResponseFromJson(jsonString);

import 'dart:convert';

import 'package:appx/models/cita.dart';

CitaResponse citaResponseFromJson(String str) => CitaResponse.fromJson(json.decode(str));

String citaResponseToJson(CitaResponse data) => json.encode(data.toJson());

class CitaResponse {
    CitaResponse({
        this.ok,
        this.cita
    });

    bool ok;
    Cita cita;

    factory CitaResponse.fromJson(Map<String, dynamic> json) => CitaResponse(
        ok: json["ok"],
        cita: Cita.fromJson(json["cita"])
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "cita": cita.toJson(),
    };
}

