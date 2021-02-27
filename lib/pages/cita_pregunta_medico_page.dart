import 'dart:convert';

import 'package:appx/global/environment.dart';
import 'package:appx/helpers/mostrar_alerta.dart';
import 'package:appx/models/usuario.dart';
import 'package:appx/services/chat_service.dart';
import 'package:appx/services/cita_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CitaPreguntaMedicoPage extends StatefulWidget {
  @override
  _CitaPreguntaMedicoPageState createState() => _CitaPreguntaMedicoPageState();
}

class _CitaPreguntaMedicoPageState extends State<CitaPreguntaMedicoPage> {
  @override
  Widget build(BuildContext context) {
    final citaService = Provider.of<CitaService>(context);

    var argPushNoti = ModalRoute.of(context).settings.arguments;
    var argPushNotiJ = jsonDecode(argPushNoti);
    String usuarioId = argPushNotiJ['usuarioId'].toString();
    String usuarioemail = argPushNotiJ['usuarioEmail'].toString();
    String usuarioNombre = argPushNotiJ['usuarioNombre'].toString();
    String sintomas = argPushNotiJ['usuarioSintomas'].toString();
    String citaId = argPushNotiJ['citaId'].toString();

    bool backPage = argPushNotiJ['backPage'];

    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              title: Text(
                'Cita - Chat',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Environment.colorApp1,
              leading: GestureDetector(
                child: Icon(Icons.arrow_back, color: Colors.white),
                onTap: () => backPage
                    ? Navigator.pop(context)
                    : Navigator.pushReplacementNamed(context, 'loading'),
              )),
          body: ListView(
            padding: EdgeInsets.all(10.0),
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Environment.colorApp1,
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        isThreeLine: true,
                        leading: CircleAvatar(
                          child: Image(
                              image: AssetImage('assets/splash_logo.jpeg'),
                              fit: BoxFit.fill),
                          maxRadius: 30,
                        ),
                        title: Text(usuarioNombre,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0)),
                        subtitle: Text(sintomas,
                            style: TextStyle(color: Colors.white)),
                      ),
                      // ignore: deprecated_member_use
                      ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                                child: Text('Ignorar',
                                    style: TextStyle(color: Colors.white)),
                                color: Colors.red,
                                onPressed: () => backPage
                                    ? Navigator.pop(context)
                                    : Navigator.pushReplacementNamed(
                                        context, 'loading')),
                            FlatButton(
                              child: Text('Iniciar Chat',
                                  style: TextStyle(color: Colors.white)),
                              color: Colors.green,
                              onPressed: citaService.autenticando
                                  ? null
                                  : () async {
                                      bool crearCitaOK = await citaService
                                          .setAceptaMedicoCita(citaId);

                                      if (crearCitaOK) {
                                        final chatService = Provider.of<ChatService>(context, listen: false);
                                        var usuario = Usuario();
                                        usuario.online = false;
                                        usuario.tipo = 'P';
                                        usuario.nombre = usuarioNombre;
                                        usuario.email = usuarioemail;
                                        usuario.uid = usuarioId;

                                        chatService.usuarioPara = usuario;
                                        Navigator.pushReplacementNamed(context, 'chat');
                                      } else {
                                        mostrarAlerta(context, 'Error',
                                            'Chat no disponible');
                                      }
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
