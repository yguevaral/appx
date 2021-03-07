import 'dart:convert';

import 'package:appx/routes/routes.dart';
import 'package:appx/services/auth_service.dart';
import 'package:appx/services/chat_service.dart';
import 'package:appx/services/cita_service.dart';
import 'package:appx/services/push_notifications_provider.dart';
import 'package:appx/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'models/usuario.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    final pushProvider = new PushNotificationsProvider();
    pushProvider.initNotifications();

    pushProvider.mensajesStream.listen((data) async {
      var data1 = jsonDecode(data);
      // print("============================================");
      // print("============================================");
      print("MAIN!!!->>>>>: ");
      print(data1);
      // print("============================================");
      // print("============================================");

      if (data1['accion'] == "chatAceptadoMedico") {

        await FlutterSecureStorage().write(key: 'tipoCitaHome', value: data1['llave3']);
        await FlutterSecureStorage().write(key: 'noti_citaid', value: data1['llave1']);
        await FlutterSecureStorage().write(key: 'noti_citaid_medico', value: data1['llave2']);

        navigatorKey.currentState.pushReplacementNamed('citasPaciente');

      }

      if (data1['accion'] == "notiCitaMedico") {
        //navigatorKey.currentState.pushNamed('citasMedico');
        Fluttertoast.showToast(
            msg: "Nueva Cita por Aceptar",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey[300],
            textColor: Colors.black,
            fontSize: 16.0);
      }
      // Navigator.pushNamed(context, 'usuarios');
      //navigatorKey.currentState.pushNamed('usuarios', arguments: data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
        ChangeNotifierProvider(create: (_) => CitaService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Appx',
        theme: ThemeData(fontFamily: 'Raleway'),
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
