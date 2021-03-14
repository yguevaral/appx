import 'package:appx/services/auth_service.dart';
import 'package:appx/widgets/boton_azul.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmpezarSeleccionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/main_logo.jpeg'),
                    width: 180.0,
                  ),
                  SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: BotonAzul(
                      text: 'Soy paciente',
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'login', arguments: 'P');
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: BotonAzul(
                      text: 'Soy médico',
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'login', arguments: 'M');
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
