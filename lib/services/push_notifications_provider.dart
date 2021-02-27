import 'dart:async';
import 'dart:convert';

import 'package:appx/models/usuario.dart';
import 'package:appx/services/usuarios_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_service.dart';

class PushNotificationsProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajesStreamController = StreamController<String>.broadcast();
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Stream<String> get mensajesStream => _mensajesStreamController.stream;

  static Future<dynamic> onBackgroundMessage(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      // final dynamic data = message['data'];
      // accionesNotificacion('onMessage', message);
      // final GlobalKey<NavigatorState> navigatorKey =
      //     new GlobalKey<NavigatorState>();
      // // message['data']['evento'] = 'onBackgroundMessage';
      // navigatorKey.currentState
      //     .pushNamed('citaPreguntaMedico', arguments: message);
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // message['evento'] = 'onLaunch';
    // _mensajesStreamController.sink.add(jsonEncode(message['data']));
    // Or do other work.
  }

  initNotifications() async {
    //Token APP Unico

    // Pedir permiso al usuairo para notis
    await _firebaseMessaging.requestNotificationPermissions();
    final token = await _firebaseMessaging.getToken();

    print('====== FCM token ==========');
    print(token);
    final usuarioService = new UsuariosService();
    usuarioService.setUsuarioTokenApp(token);

    _firebaseMessaging.configure(
      onMessage: onMessage,
      onBackgroundMessage: onBackgroundMessage,
      onLaunch: onLaunch,
      onResume: onResume,
    );
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    // message['evento'] = "onMessage";
    // print('========= onMessage');
    // message['data']['evento'] = 'onMessage';
    // _mensajesStreamController.sink.add(jsonEncode(message['data']));
    accionesNotificacion('onMessage', message);
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {
    // print('========= onLaunch');
    // message['data']['evento'] = 'onLaunch';
    // _mensajesStreamController.sink.add(jsonEncode(message['data']));
    accionesNotificacion('onLaunch', message);
  }

  Future<dynamic> onResume(Map<String, dynamic> message) async {
    // print('========= onResume');
    // message['data']['evento'] = 'onResume';
    // _mensajesStreamController.sink.add(jsonEncode(message['data']));
    accionesNotificacion('onResume', message);
  }

  accionesNotificacion(String evento, Map<String, dynamic> message) {
    // print("============================================");
    // print("============================================");
    print("Centralizado!!!->>>>>: $evento");
    print(message);
    // print("============================================");
    // print("============================================");
    _mensajesStreamController.sink.add(jsonEncode(message['data']));

    // if (evento == 'onMessage' &&
    //     message['data']['accion'] == "chatAceptadoMedico") {
    //   var usuario = Usuario();
    //   usuario.online = false;
    //   usuario.tipo = 'M';
    //   usuario.nombre = 'Medico';
    //   usuario.email = '';
    //   usuario.uid = message['data']['llave1'];
    //   print('asdfasdf');
    //   navigatorKey.currentState.pushNamed('chat', arguments: usuario);
    // }
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}
