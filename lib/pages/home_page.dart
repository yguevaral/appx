import 'package:appx/global/environment.dart';
import 'package:appx/helpers/mostrar_alerta.dart';
import 'package:appx/models/usuario.dart';
import 'package:appx/services/auth_service.dart';
import 'package:appx/services/chat_service.dart';
import 'package:appx/services/socket_service.dart';
import 'package:appx/services/usuarios_service.dart';
import 'package:appx/widgets/header_drawer.dart';
import 'package:appx/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usuarioService = new UsuariosService();
  bool _enlinea;

  @override
  void initState() {
    super.initState();
    _enlinea = true;
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    final socketService = Provider.of<SocketService>(context);
    // _enlinea = usuario.online;
    // usuario.nombre

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
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Hola ${authService.usuario.nombre}',
                    style:
                        TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                Text('Que podemos hacer ti?',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                SizedBox(height: 10.0),
                SwitchListTile(
                  value: _enlinea,
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                  title: Text(
                    _enlinea ? "En linea" : "Fuera de linea",
                    style: TextStyle(
                        color: _enlinea ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                  onChanged: (value) {
                    setState(() {
                      _enlinea = value;
                    });
                  },
                ),
                SizedBox(height: 10.0),
                Table(
                  children: [
                    TableRow(children: [
                      _crearBotonRedondeado(
                          'Chat',
                          'assets/iconChat.png',
                          _drawChatPage,
                          context,
                          Alignment.topLeft,
                          Alignment.bottomRight),
                      _crearBotonRedondeado(
                          'Videollamada',
                          'assets/iconVideoLlamada.png',
                          _drawVideoLlamada,
                          context,
                          Alignment.topRight,
                          Alignment.bottomLeft)
                    ]),
                    TableRow(children: [
                      _crearBotonRedondeado(
                          'Cita a domicilio',
                          'assets/iconCita.png',
                          _drawCita,
                          context,
                          Alignment.bottomLeft,
                          Alignment.topRight),
                      _crearBotonRedondeado(
                          'Historial',
                          'assets/historial_medico.png',
                          _drawHistorial,
                          context,
                          Alignment.bottomRight,
                          Alignment.topLeft)
                    ])
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Widget _crearBotonRedondeado(
      String texto,
      String strIcon,
      Function fntOnPresed,
      context,
      AlignmentGeometry begin,
      AlignmentGeometry end) {
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
        child: Container(
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
              Text(texto,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 15.0)
            ],
          ),
        ),
      ),
      onTap: () => fntOnPresed(context),
    );
  }

  _drawChatPage(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuario = authService.usuario;

    if (usuario.tipo == 'P') {
      Navigator.pushNamed(context, 'cita');
    }
    else {
      mostrarAlerta(context, 'Chats', 'Mostrar chats activos del medico');

    }

  }

  _drawVideoLlamada(BuildContext context) {
    mostrarAlerta(context, 'Alerta', 'Pronto estara disponible esta opcion');
    // Navigator.pushNamed(context, 'usuarios');
  }

  _drawCita(BuildContext context) {
    mostrarAlerta(context, 'Alerta', 'Pronto estara disponible esta opcion');
    // Navigator.pushNamed(context, 'usuarios');
  }

  _drawHistorial(BuildContext context) {
    Navigator.pushNamed(context, 'usuarios');
  }
}
