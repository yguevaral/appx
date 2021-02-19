// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:appx/models/usuario.dart';

UsuariosResponse usuariosResponseFromJson(String str) => UsuariosResponse.fromJson(json.decode(str));

String usuariosResponseToJson(UsuariosResponse data) => json.encode(data.toJson());

class UsuariosResponse {
    UsuariosResponse({
        this.ok,
        this.msg,
        this.desde,
        this.usuarios,
    });

    bool ok;
    String msg;
    int desde;
    List<Usuario> usuarios;

    factory UsuariosResponse.fromJson(Map<String, dynamic> json) => UsuariosResponse(
        ok: json["ok"],
        msg: json["msg"],
        desde: json["desde"],
        usuarios: List<Usuario>.from(json["usuarios"].map((x) => Usuario.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "desde": desde,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
    };
}

