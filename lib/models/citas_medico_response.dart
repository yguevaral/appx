// To parse this JSON data, do
//
//     final medicoCitasResponse = medicoCitasResponseFromJson(jsonString);

import 'dart:convert';

MedicoCitasResponse medicoCitasResponseFromJson(String str) => MedicoCitasResponse.fromJson(json.decode(str));

String medicoCitasResponseToJson(MedicoCitasResponse data) => json.encode(data.toJson());

class MedicoCitasResponse {
    MedicoCitasResponse({
        this.ok,
        this.medicoCitas,
    });

    bool ok;
    List<MedicoCita> medicoCitas;

    factory MedicoCitasResponse.fromJson(Map<String, dynamic> json) => MedicoCitasResponse(
        ok: json["ok"],
        medicoCitas: List<MedicoCita>.from(json["medicoCitas"].map((x) => MedicoCita.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "medicoCitas": List<dynamic>.from(medicoCitas.map((x) => x.toJson())),
    };
}

class MedicoCita {
    MedicoCita({
        this.usuarioMedico,
        this.tipo,
        this.id,
        this.usuarioPaciente,
        this.sintomas,
        this.estado,
        this.createdAt,
        this.updatedAt,
    });

    dynamic usuarioMedico;
    String tipo;
    String id;
    UsuarioPaciente usuarioPaciente;
    String sintomas;
    String estado;
    DateTime createdAt;
    DateTime updatedAt;

    factory MedicoCita.fromJson(Map<String, dynamic> json) => MedicoCita(
        usuarioMedico: json["usuario_medico"],
        tipo: json["tipo"],
        id: json["_id"],
        usuarioPaciente: UsuarioPaciente.fromJson(json["usuario_paciente"]),
        sintomas: json["sintomas"],
        estado: json["estado"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "usuario_medico": usuarioMedico,
        "tipo": tipo,
        "_id": id,
        "usuario_paciente": usuarioPaciente.toJson(),
        "sintomas": sintomas,
        "estado": estado,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}

class UsuarioPaciente {
    UsuarioPaciente({
        this.online,
        this.tipo,
        this.sintoma,
        this.edad,
        this.plataforma,
        this.appToken,
        this.medicoOnline,
        this.id,
        this.email,
        this.password,
        this.nombre,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    bool online;
    String tipo;
    String sintoma;
    String edad;
    String plataforma;
    String appToken;
    bool medicoOnline;
    String id;
    String email;
    String password;
    String nombre;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    factory UsuarioPaciente.fromJson(Map<String, dynamic> json) => UsuarioPaciente(
        online: json["online"],
        tipo: json["tipo"],
        sintoma: json["sintoma"],
        edad: json["edad"],
        plataforma: json["plataforma"],
        appToken: json["app_token"],
        medicoOnline: json["medico_online"],
        id: json["_id"],
        email: json["email"],
        password: json["password"],
        nombre: json["nombre"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "online": online,
        "tipo": tipo,
        "sintoma": sintoma,
        "edad": edad,
        "plataforma": plataforma,
        "app_token": appToken,
        "medico_online": medicoOnline,
        "_id": id,
        "email": email,
        "password": password,
        "nombre": nombre,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
