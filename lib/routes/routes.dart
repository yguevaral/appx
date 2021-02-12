import 'package:appx/pages/chat_page.dart';
import 'package:appx/pages/loading_page.dart';
import 'package:appx/pages/login_page.dart';
import 'package:appx/pages/register_page.dart';
import 'package:appx/pages/usuarios_page.dart';
import 'package:flutter/cupertino.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios' : (_) => UsuariosPage(),
  'chat' : (_) => ChatPage(),
  'login' : (_) => LoginPage(),
  'register' : (_) => RegisterPage(),
  'loading' : (_) => LoadingPage()
};
