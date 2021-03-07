import 'dart:async';
import 'dart:convert';

import 'package:appx/global/environment.dart';
import 'package:appx/helpers/mostrar_alerta.dart';
import 'package:appx/services/auth_service.dart';
import 'package:appx/services/socket_service.dart';
import 'package:appx/services/usuarios_service.dart';
import 'package:appx/widgets/header_drawer.dart';
import 'package:appx/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usuarioService = new UsuariosService();
  bool _enlinea;
  int alertaChat = 0;
  int alertaVideoChat = 0;
  int alertaDomicilio = 0;
  int alertaHistorico = 0;
  Timer timerAlerta;

  @override
  void initState() {
    super.initState();
    _enlinea = true;
    getAlertas();
  }

  @override
  void dispose() {
    super.dispose();
    timerAlerta.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    // final usuario = authService.usuario;
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
        appBar: AppBar(
          title: HeaderDrawer(),
          elevation: 1,
          backgroundColor: Environment.colorApp1,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.Online)
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : Icon(Icons.offline_bolt, color: Colors.red),
            )
          ],
        ),
        drawer: MenuWidget(),
        body:
            /*FutureBuilder(
            future: getAlertas(context),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return*/
            SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Hola ${authService.usuario.nombre}', style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                Text('Que podemos hacer ti?', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.grey)),
                SizedBox(height: 10.0),
                _showEnLineaMedico(authService.usuario.tipo),
                SizedBox(height: 10.0),
                Table(
                  children: [
                    TableRow(children: [
                      _crearBotonRedondeado('Chat', 'assets/iconChat.png', _drawChatPage, context, Alignment.topLeft,
                          Alignment.bottomRight, alertaChat),
                      _crearBotonRedondeado('Videollamada', 'assets/iconVideoLlamada.png', _drawVideoLlamada, context,
                          Alignment.topRight, Alignment.bottomLeft, alertaVideoChat)
                    ]),
                    TableRow(children: [
                      _crearBotonRedondeado('Cita a domicilio', 'assets/iconCita.png', _drawCita, context, Alignment.bottomLeft,
                          Alignment.topRight, alertaDomicilio),
                      _crearBotonRedondeado('Historial', 'assets/historial_medico.png', _drawHistorial, context,
                          Alignment.bottomRight, Alignment.topLeft, alertaHistorico)
                    ])
                  ],
                )
              ],
            ),
          ),
        ) //;
        //}
        //)
        );
  }

  Widget _crearBotonRedondeado(String texto, String strIcon, Function fntOnPresed, context, AlignmentGeometry begin,
      AlignmentGeometry end, int numeroAlerta) {
    return GestureDetector(
      child: Container(
        height: 130.0,
        margin: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            colors: [
              Environment.colorApp1,
              Color.fromRGBO(95, 161, 205, 1.0),
              Color.fromRGBO(165, 221, 235, 1.0),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Stack(
          children: [
            _showAlertaNumero(numeroAlerta),
            Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 2.0),
                  CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.transparent,
                      child: Image(
                        image: AssetImage(strIcon),
                        fit: BoxFit.cover,
                      )),
                  Text(texto, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 15.0)
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () => fntOnPresed(context),
    );
  }

  _drawChatPage(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuario = authService.usuario;

    await FlutterSecureStorage().write(key: 'tipoCitaHome', value: "C");

    if (usuario.tipo == 'P') {
      // final citasService = Provider.of<CitaService>(context, listen: false);

      // List<Cita> citas = await citasService.getCitasPaciente('C');

      // if (alertaChat > 0) {
      // Navigator.pushNamed(context, 'citasPaciente', arguments: citas);
      Navigator.pushNamed(context, 'citasPaciente');
      // } else {
      //   Navigator.pushNamed(context, 'cita');
      // }
    } else {
      Navigator.pushNamed(context, 'citasMedico');
    }
  }

  _drawVideoLlamada(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuario = authService.usuario;

    await FlutterSecureStorage().write(key: 'tipoCitaHome', value: "V");

    //mostrarAlerta(context, 'Alerta', 'Pronto estara disponible esta opcion');
    if (usuario.tipo == 'P') {
      // Navigator.pushNamed(context, 'vcitasPaciente');
      Navigator.pushNamed(context, 'citasPaciente');
    } else {
      // Navigator.pushNamed(context, 'vcitasMedico');
      Navigator.pushNamed(context, 'citasMedico');
    }
  }

  _drawCita(BuildContext context) {
    mostrarAlerta(context, 'Alerta', 'Pronto estara disponible esta opcion');
    // Navigator.pushNamed(context, 'usuarios');
  }

  _drawHistorial(BuildContext context) async {
    // final storage = new FlutterSecureStorage();

    // final token = await storage.read(key: 'notiBack');

    // mostrarAlerta(context, "NotiBack", token.toString());
    Navigator.pushNamed(context, 'usuarios');
  }

  _showEnLineaMedico(String tipo) {
    if (tipo == "M") {
      return SwitchListTile(
        value: _enlinea,
        activeColor: Colors.green,
        inactiveThumbColor: Colors.red,
        title: Text(
          _enlinea ? "En linea" : "Fuera de linea",
          style: TextStyle(color: _enlinea ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
        ),
        controlAffinity: ListTileControlAffinity.trailing,
        onChanged: (value) {
          setState(() {
            _enlinea = value;
            usuarioService.setEnlinea(_enlinea);
          });
        },
      );
    } else {
      return Container(
        height: 30.0,
      );
    }
  }

  _showAlertaNumero(int numeroAlerta) {
    if (numeroAlerta > 0) {
      return Container(
        width: double.infinity,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
              // color: Colors.red,
              padding: const EdgeInsets.all(8.0),
              child: Text(numeroAlerta.toString(), style: TextStyle(color: Environment.colorApp1, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  getAlertas() {
    if (timerAlerta != null) {
      timerAlerta.cancel();
    }

    timerAlerta = Timer.periodic(new Duration(seconds: 3), (timer) async {
      final arrJsonHomeAlerta = jsonDecode(await usuarioService.getHomeAlerta());
      // print(arrJsonHomeAlerta);
      alertaChat = arrJsonHomeAlerta['alerta_chat'];
      alertaVideoChat = arrJsonHomeAlerta['alerta_videollamada'];
      alertaDomicilio = arrJsonHomeAlerta['alerta_domicilio'];
      alertaHistorico = arrJsonHomeAlerta['alerta_historial'];

      // print('seeett Timer!!!');
      setState(() {});
    });
  }
}
