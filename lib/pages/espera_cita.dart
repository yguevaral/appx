import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class EsperarCitaPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(70, 138, 215, 1.0),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back, color: Colors.white),
            onTap: () => Navigator.pushReplacementNamed(context, 'citasPaciente'),
          )
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          color: Color.fromRGBO(70, 138, 215, 1.0),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image(
                    image: AssetImage('assets/logo appx-07_web.png'),
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.50
                  ),
                ),
                SizedBox(height: 50.0),
                Center(
                  child: Text('Estamos contactando', style: TextStyle(color: Colors.white, fontSize: 20.0))
                ),
                Center(
                  child: Text('a un médico para ti.', style: TextStyle(color: Colors.white, fontSize: 20.0))
                ),
                Center(
                  child: Image(
                    image: AssetImage('assets/cargando.gif'),
                    fit: BoxFit.contain,
                    width: double.infinity
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }




}
