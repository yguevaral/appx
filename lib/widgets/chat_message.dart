import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:appx/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final AnimationController animationController;
  final String tipo;
  final Uint8List imageBytes;

  const ChatMessage(
      {Key key, @required this.texto, @required this.uid, @required this.animationController, String this.tipo = 'T', this.imageBytes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: this.uid == authService.usuario.uid ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    // Uint8List _image = this.texto as Uint8List;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 5.0, left: 50.0, right: 5.0),
        child: this.tipo == "T" ? Text(this.texto, style: TextStyle(color: Colors.white)) : Image.memory(this.imageBytes),
        decoration: BoxDecoration(color: Color(0xff4D9Ef6), borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 5.0, right: 50.0, left: 5.0),
        child: this.tipo == "T" ? Text(this.texto, style: TextStyle(color: Colors.black87)) : Image.memory(this.imageBytes),
        decoration: BoxDecoration(color: Color(0xffE4E5E8), borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }
}
