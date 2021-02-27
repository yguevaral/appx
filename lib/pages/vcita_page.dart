import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:appx/global/environment.dart';
import 'package:appx/helpers/mostrar_alerta.dart';
import 'package:appx/models/usuario.dart';
import 'package:appx/pages/call.dart';
import 'package:appx/services/auth_service.dart';
import 'package:appx/services/chat_service.dart';
import 'package:appx/services/cita_service.dart';
import 'package:appx/services/socket_service.dart';
import 'package:appx/services/usuarios_service.dart';
import 'package:appx/widgets/boton_azul.dart';
import 'package:appx/widgets/header_drawer.dart';
import 'package:appx/widgets/menu_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VideoCitaPage extends StatefulWidget {
  @override
  _VideoCitaPageState createState() => _VideoCitaPageState();
}

class _VideoCitaPageState extends State<VideoCitaPage> {
  final usuarioService = new UsuariosService();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  final sintomasCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    final socketService = Provider.of<SocketService>(context);
    final citaService = Provider.of<CitaService>(context);

    return Scaffold(
        appBar: AppBar(
          title: HeaderDrawer(),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Environment.colorApp1,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back, color: Colors.white),
            onTap: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.Online)
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : Icon(Icons.offline_bolt, color: Colors.red),
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              height: MediaQuery.of(context).size.height * 0.90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Text(
                            'Orientación médica por Chat',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Environment.colorApp1),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Para encontrar al médico indicado que atenderá tu orientación médica, cuéntanos más sobre tus síntomas.',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextField(
                              maxLines: 10,
                              controller: sintomasCtrl,
                              autocorrect: false,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  // focusedBorder: InputBorder.none,
                                  hintText: 'Describe tus síntomas:')),
                          SizedBox(height: 20),
                          BotonAzul(
                              text: 'Iniciar Chat', onPressed: _fntPageCall)
                          // onPressed: citaService.autenticando
                          //     ? null
                          //     : () async {
                          //         FocusScope.of(context).unfocus();
                          //         final crearCitaOK =
                          //             await citaService.crearCita(
                          //                 sintomasCtrl.text.trim(), 'C');
                          //         if (crearCitaOK) {
                          //           Navigator.pushReplacementNamed(
                          //               context, 'esperarCita');
                          //         } else {
                          //           mostrarAlerta(context, 'Error',
                          //               'Chat no disponible');
                          //         }
                          //       }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _fntPageCall() {
    onJoin();
  }

  Future<void> onJoin() async {
    String strIdCita = 'appx1';
    if (strIdCita.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: strIdCita,
            role: ClientRole.Broadcaster,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}