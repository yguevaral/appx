import 'package:appx/routes/routes.dart';
import 'package:appx/services/auth_service.dart';
import 'package:appx/services/chat_service.dart';
import 'package:appx/services/cita_service.dart';
import 'package:appx/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
        title: 'Appx',
        theme: ThemeData(fontFamily: 'Raleway'),
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}