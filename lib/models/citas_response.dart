// To parse this JSON data, do
//
//     final citasResponse = citasResponseFromJson(jsonString);

import 'dart:convert';

CitasResponse citasResponseFromJson(String str) => CitasResponse.fromJson(json.decode(str));

String citasResponseToJson(CitasResponse data) => json.encode(data.toJson());

class CitasResponse {
    CitasResponse({
        this.ok,
        this.citas,
    });

    bool ok;
    List<Cita> citas;

    factory CitasResponse.fromJson(Map<String, dynamic> json) => CitasResponse(
        ok: json["ok"],
        citas: List<Cita>.from(json["citas"].map((x) => Cita.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "citas": List<dynamic>.from(citas.map((x) => x.toJson())),
    };
}

class Cita {
    Cita({
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

    factory Cita.fromJson(Map<String, dynamic> json) => Cita(
        usuarioMedico: json["usuario_medico"],
        tipo: json["tipo"],
        id: json["_id"],
        usuarioPaciente: usuarioPacienteValues.map[json["usuario_paciente"]],
        sintomas: json["sintomas"],
        estado: json["estado"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "usuario_medico": usuarioMedico,
        "tipo": tipo,
        "_id": id,
        "usuario_paciente": usuarioPacienteValues.reverse[usuarioPaciente],
        "sintomas": sintomasValues.reverse[sintomas],
        "estado": estado,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}

enum Estado { SP }

final estadoValues = "SP";

enum Sintomas { TENGO_DOLORES_DE_CABEZA_Y_ESTMAGO_MUY_SEGUIDOS, MIS_SINTOMAS_COMO_PACIENTE }

final sintomasValues = EnumValues({
    "mis sintomas como paciente": Sintomas.MIS_SINTOMAS_COMO_PACIENTE,
    "tengo dolores de cabeza y estómago muy seguidos": Sintomas.TENGO_DOLORES_DE_CABEZA_Y_ESTMAGO_MUY_SEGUIDOS
});

enum Tipo { C }

final tipoValues = "C";

enum UsuarioPaciente { THE_6034_CD093_ED1_F60015_C17267 }

final usuarioPacienteValues = EnumValues({
    "6034cd093ed1f60015c17267": UsuarioPaciente.THE_6034_CD093_ED1_F60015_C17267
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
