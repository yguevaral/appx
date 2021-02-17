import 'package:appx/pages/login_page.dart';
import 'package:appx/pages/usuarios_page.dart';
import 'package:appx/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: checkLoginState(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Center(
              child: Text('Espere...'),
            );
          }),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      // conectar al socket server
      // Navigator.pushReplacementNamed(context, 'usuarios');
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___ ) => UsuariosPage(),
          transitionDuration: Duration(milliseconds: 0)
        )
      );
    }
    else{
      // Navigator.pushReplacementNamed(context, 'login');
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___ ) => LoginPage(),
          transitionDuration: Duration(milliseconds: 0)
        )
      );
    }
  }
}
