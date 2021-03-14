import 'package:appx/widgets/boton_azul.dart';
import 'package:flutter/material.dart';

class EmpezarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  Image(
                    image: AssetImage('assets/empezar-appx.png'),
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: BotonAzul(
                      text: 'Empezar',
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'empezarSeleccion');
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
