// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    Usuario({
        this.online,
        this.tipo,
        this.nombre,
        this.email,
        this.uid,
    });

    bool online;
    String tipo;
    String nombre;
    String email;
    String uid;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        tipo: json["tipo"],
        nombre: json["nombre"],
        email: json["email"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "online": online,
        "tipo": tipo,
        "nombre": nombre,
        "email": email,
        "uid": uid,
    };
}
