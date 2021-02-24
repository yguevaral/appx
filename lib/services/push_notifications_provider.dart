import 'dart:async';

import 'package:appx/services/usuarios_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajesStreamController = StreamController<String>.broadcast();

  Stream<String> get mensajesStream => _mensajesStreamController.stream;

  static Future<dynamic> onBackgroundMessage(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

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
    print('========= onMessage');
    print('message: $message');

    final argumento = message['data']['citaId'];
    _mensajesStreamController.sink.add(argumento);

    print('==argumento===========>>>>> ${argumento}');
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {
    print('========= onLaunch');
    print('message: $message');
    final argumento = message['data']['citaId'];
    _mensajesStreamController.sink.add(argumento);
  }

  Future<dynamic> onResume(Map<String, dynamic> message) async {
    print('========= onResume');
    print('message: $message');
    final argumento = message['data']['citaId'];

    print('==argumento===========>>>>> ${argumento}');
    _mensajesStreamController.sink.add(argumento);
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}
