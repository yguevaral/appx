// To parse this JSON data, do
//
//     final cita = citaFromJson(jsonString);

import 'dart:convert';

Cita citaFromJson(String str) => Cita.fromJson(json.decode(str));

String citaToJson(Cita data) => json.encode(data.toJson());

class Cita {
  Cita({
    this.id,
    this.usuario_paciente,
    this.usuario_medico,
    this.estado,
    this.sintomas,
    this.tipo,
  });

  String id;
  String usuario_paciente;
  String usuario_medico;
  String estado;
  String sintomas;
  String tipo;

  factory Cita.fromJson(Map<String, dynamic> json) => Cita(
        id: json["id"],
        usuario_paciente: json["usuario_paciente"],
        usuario_medico: json["usuario_medico"],
        estado: json["estado"],
        sintomas: json["sintomas"],
        tipo: json["tipo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "usuario_paciente": usuario_paciente,
        "usuario_medico": usuario_medico,
        "estado": estado,
        "sintomas": sintomas,
        "tipo": tipo,
      };
}
