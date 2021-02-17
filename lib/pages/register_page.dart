import 'package:appx/helpers/mostrar_alerta.dart';
import 'package:appx/services/auth_service.dart';
import 'package:appx/widgets/boton_azul.dart';
import 'package:appx/widgets/custom_input.dart';
import 'package:appx/widgets/labels.dart';
import 'package:appx/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
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
                    titulo: 'Registro',
                  ),
                  _Form(),
                  Labels(
                    ruta: 'login',
                    titulo: 'Ya tienes una cuenta?',
                    subtitulo: 'Ingresa ahora!',
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
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsetsDirectional.only(top: 40.0),
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.perm_identity,
            placeHolder: 'Nombre',
            keyboardType: TextInputType.text,
            textEditingController: nameCtrl,
          ),
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
            text: 'Crear Cuenta',
            onPressed: authService.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final registroOk = await authService.register(
                        nameCtrl.text.trim(),
                        emailCtrl.text.trim(),
                        passCtrl.text.trim());

                    if (registroOk == true) {
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      mostrarAlerta(context, 'Registro Incorecto', registroOk);
                    }
                  },
          )
        ],
      ),
    );
  }
}
