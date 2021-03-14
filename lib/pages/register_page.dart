import 'package:appx/global/environment.dart';
import 'package:appx/helpers/mostrar_alerta.dart';
import 'package:appx/helpers/url_navegador.dart';
import 'package:appx/services/auth_service.dart';
import 'package:appx/services/socket_service.dart';
import 'package:appx/widgets/boton_azul.dart';
import 'package:appx/widgets/custom_input.dart';
import 'package:appx/widgets/labels.dart';
import 'package:appx/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Logo(
                    titulo: 'Regístrate',
                  ),
                  _Form(),
                  Labels(
                    ruta: 'login',
                    titulo: 'Ya tienes una cuenta?',
                    subtitulo: 'Ingresa ahora!',
                  ),
                  GestureDetector(
                    onTap: () => showUrlNavegadorInterno('https://appxguatemala.app/'),
                    child: Text('Terminos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200)),
                  )
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
  final edadCtrl = TextEditingController();

  String _opcioneSeleccionadaSintomas = 'Malestar General';
  List<String> _sintomas = Environment.registroSintomas;

  String _opcioneSeleccionadaGenero = 'Masculino';
  List<String> _genero = Environment.registroGenero;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsetsDirectional.only(top: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 550.0,
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.perm_identity,
            placeHolder: 'Nombre Completo',
            keyboardType: TextInputType.text,
            textEditingController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Correo Electrónico',
            keyboardType: TextInputType.emailAddress,
            textEditingController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeHolder: 'Contraseña',
            isPassword: true,
            textEditingController: passCtrl,
          ),
          Container(
            height: 50.0,
            width: double.infinity,
            padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 20.0),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.05), offset: Offset(0, 5), blurRadius: 5)]),
            child: Container(
              width: 200.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 15.0),
                  Image(
                    image: AssetImage('assets/iconSymptoms.png'),
                    width: 22.0,
                  ),
                  SizedBox(width: 10.0),
                  SafeArea(
                    child: DropdownButton(
                      underline: SizedBox(),
                      value: _opcioneSeleccionadaSintomas,
                      items: getOpcionesDropdown(),
                      style: TextStyle(color: Colors.grey, fontSize: 18.0),
                      onChanged: (opt) {
                        setState(() {
                          _opcioneSeleccionadaSintomas = opt;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 50.0,
            width: double.infinity,
            padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 20.0),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.05), offset: Offset(0, 5), blurRadius: 5)]),
            child: Container(
              width: 200.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 15.0),
                  Image(
                    image: AssetImage('assets/icon_gender.png'),
                    width: 22.0,
                  ),
                  SizedBox(width: 10.0),
                  SafeArea(
                    child: DropdownButton(
                      underline: SizedBox(),
                      value: _opcioneSeleccionadaGenero,
                      items: getOpcionesDropdownGenero(),
                      style: TextStyle(color: Colors.grey, fontSize: 18.0),
                      onChanged: (opt) {
                        setState(() {
                          _opcioneSeleccionadaGenero = opt;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomInput(
            icon: Icons.face,
            placeHolder: 'Edad',
            keyboardType: TextInputType.number,
            textEditingController: edadCtrl,
          ),
          BotonAzul(
            text: 'Crear Cuenta',
            onPressed: authService.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    if (int.parse(edadCtrl.text) < 18 ) {
                      mostrarAlerta(context, 'Alerta', 'Edad mínima de registro: 18');
                      return false;
                    }

                    final registroOk = await authService.register(nameCtrl.text.trim(), emailCtrl.text.trim(),
                        passCtrl.text.trim(), _opcioneSeleccionadaSintomas, _opcioneSeleccionadaGenero, edadCtrl.text.trim());

                    if (registroOk == true) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'home');
                    } else {
                      mostrarAlerta(context, 'Registro Incorecto', registroOk);
                    }
                  },
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = new List();
    _sintomas.forEach((sintoma) {
      lista.add(DropdownMenuItem(
        child: Text(sintoma),
        value: sintoma,
      ));
    });

    return lista;
  }

  List<DropdownMenuItem<String>> getOpcionesDropdownGenero() {
    List<DropdownMenuItem<String>> lista = new List();
    _genero.forEach((genero) {
      lista.add(DropdownMenuItem(
        child: Text(genero),
        value: genero,
      ));
    });

    return lista;
  }
}
