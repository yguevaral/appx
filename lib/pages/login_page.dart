import 'package:appx/helpers/mostrar_alerta.dart';
import 'package:appx/services/auth_service.dart';
import 'package:appx/services/socket_service.dart';
import 'package:appx/widgets/boton_azul.dart';
import 'package:appx/widgets/custom_input.dart';
import 'package:appx/widgets/labels.dart';
import 'package:appx/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Logo(
                    titulo: 'Messenger',
                  ),
                  _Form(),
                  Labels(
                    ruta: 'register',
                    titulo: 'No tienes una cuenta?',
                    subtitulo: 'Crea una ahora!',
                  ),
                  Text('Terminos y condiciones de uso',
                      style: TextStyle(fontWeight: FontWeight.w200))
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  _Form({Key key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsetsDirectional.only(top: 40.0),
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textEditingController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeHolder: 'Contraseña',
            isPassword: true,
            textEditingController: passCtrl,
          ),
          BotonAzul(
            text: 'Ingrese',
            onPressed: authService.autenticando
                ? null
                : () async {
                    // bajar el teclado
                    FocusScope.of(context).unfocus();
                    final loginOk = await authService.login(
                        emailCtrl.text.trim(), passCtrl.text.trim());
                    if (loginOk) {
                      // Navegar a otra pantalla
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      mostrarAlerta(context, 'Login incorrecto',
                          'Revise sus credenciales nuevamente');
                    }
                  },
          )
        ],
      ),
    );
  }
}
