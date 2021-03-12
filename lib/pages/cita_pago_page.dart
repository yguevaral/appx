import 'package:appx/global/environment.dart';
import 'package:appx/helpers/mostrar_alerta.dart';
import 'package:appx/models/usuario.dart';
import 'package:appx/services/auth_service.dart';
import 'package:appx/services/cita_service.dart';
import 'package:appx/services/socket_service.dart';
import 'package:appx/services/usuarios_service.dart';
import 'package:appx/widgets/boton_azul.dart';
import 'package:appx/widgets/custom_input.dart';
import 'package:appx/widgets/header_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CitaPagoPage extends StatefulWidget {
  @override
  _CitaPagoPageState createState() => _CitaPagoPageState();
}

class _CitaPagoPageState extends State<CitaPagoPage> {
  final usuarioService = new UsuariosService();
  // RefreshController _refreshController =
  //     RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  final sintomasCtrl = TextEditingController();
  final tcNumeroTarjetaCtrl = TextEditingController();
  final tcNombreTarjetaCtrl = TextEditingController();
  final tcMesTarjetaCtrl = TextEditingController();
  final tcAnioTarjetaCtrl = TextEditingController();
  final tcCVVTarjetaCtrl = TextEditingController();

  String tipoCitaHome;
  String precioCita;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    // final usuario = authService.usuario;
    final socketService = Provider.of<SocketService>(context);
    final citaService = Provider.of<CitaService>(context);

    this.tipoCitaHome = authService.getTipoCitaHombre().toString();
    this.precioCita = authService.getPrecioCitaHombre().toString();

    final strSintomas = ModalRoute.of(context).settings.arguments;

    print('================ Sintormas: ${strSintomas}, ${this.tipoCitaHome}, ${this.precioCita} ===============');

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
        backgroundColor: Colors.grey[200],
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
                            'Completar datos de tarjeta',
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Environment.colorApp1),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          CustomInput(
                            icon: Icons.credit_card,
                            placeHolder: 'Numero de Tarjeta',
                            keyboardType: TextInputType.number,
                            textEditingController: tcNumeroTarjetaCtrl,
                            maxLength: 16,
                          ),
                          CustomInput(
                              icon: Icons.perm_identity,
                              placeHolder: 'Nombre de Tarjeta',
                              keyboardType: TextInputType.text,
                              textEditingController: tcNombreTarjetaCtrl),
                          Table(
                            children: [
                              TableRow(children: [
                                Column(
                                  children: [
                                    CustomInput(
                                      icon: Icons.date_range,
                                      placeHolder: 'DD',
                                      keyboardType: TextInputType.number,
                                      textEditingController: tcMesTarjetaCtrl,
                                      maxLength: 2,
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomInput(
                                      icon: Icons.date_range,
                                      placeHolder: 'YY',
                                      keyboardType: TextInputType.number,
                                      textEditingController: tcAnioTarjetaCtrl,
                                      maxLength: 2,
                                    )
                                  ],
                                )
                              ])
                            ],
                          ),
                          CustomInput(
                            icon: Icons.short_text,
                            placeHolder: 'Codigo CVV',
                            keyboardType: TextInputType.number,
                            textEditingController: tcCVVTarjetaCtrl,
                            maxLength: 3,
                          ),
                          Center(
                            child: Text('Total a Pagar: ' + this.precioCita,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          BotonAzul(
                              text: this.tipoCitaHome == 'C' ? 'Iniciar Chat' : 'Iniciar Video Llamada',
                              onPressed: citaService.autenticando
                                  ? null
                                  : () async {
                                      // FocusScope.of(context).unfocus();
                                      final arrJsonRes = await citaService.crearCita(
                                          strSintomas,
                                          this.tipoCitaHome,
                                          tcNumeroTarjetaCtrl.text.trim(),
                                          tcCVVTarjetaCtrl.text.trim(),
                                          tcNombreTarjetaCtrl.text.trim(),
                                          tcAnioTarjetaCtrl.text.trim(),
                                          tcMesTarjetaCtrl.text.trim());

                                      print(arrJsonRes['msg']);
                                      if (arrJsonRes['ok']) {
                                        Fluttertoast.showToast(
                                            msg: "Pago Aprobado",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            timeInSecForIosWeb: 5,
                                            backgroundColor: Colors.grey[300],
                                            textColor: Colors.black,
                                            fontSize: 16.0);
                                        Navigator.pushReplacementNamed(context, 'esperarCita');
                                      } else {
                                        mostrarAlerta(context, 'Alerta', arrJsonRes['msg']);
                                      }
                                    }),
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
}
