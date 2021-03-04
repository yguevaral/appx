import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:appx/global/environment.dart';
import 'package:appx/helpers/mostrar_alerta.dart';
import 'package:appx/models/citas_response.dart';
import 'package:appx/pages/call.dart';
import 'package:appx/services/cita_service.dart';
import 'package:appx/services/socket_service.dart';
import 'package:appx/widgets/header_drawer.dart';
import 'package:appx/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VCitasPacientePage extends StatefulWidget {
  @override
  _VCitasPacientePageState createState() => _VCitasPacientePageState();
}

class _VCitasPacientePageState extends State<VCitasPacientePage> {
  final citaService = new CitaService();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Cita> citas = [];

  @override
  void initState() {
    this._cargarCitas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    // final usuario = authService.usuario;
    final socketService = Provider.of<SocketService>(context);

    // final argCitas = ModalRoute.of(context).settings.arguments;

    // print('================ argumentos: ${argCitas} ===============');
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
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        physics: BouncingScrollPhysics(),
        onRefresh: _cargarCitas,
        // header: WaterDropHeader(
        //   complete: Icon(Icons.check, color: Colors.blue[400]),
        //   waterDropColor: Colors.blue[400],
        // ),
        child: _listViewCitas(),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            if (this.citas.length > 5) {
              mostrarAlerta(
                  context, 'Alerta', 'Solo puedes tener 5 citas en proceso');
            } else {
              Navigator.pushNamed(context, 'videocita');
            }
          }),
    );
  }

  ListView _listViewCitas() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTitle(citas[i], i),
      separatorBuilder: (_, i) => Divider(),
      itemCount: citas.length,
    );
  }

  ListTile _usuarioListTitle(Cita cita, int index) {
    index++;
    return ListTile(
      title: Text(cita.sintomas),
      subtitle: Text(
          Environment.convertToAgo(DateTime.parse(cita.createdAt.toString()))),
      leading: CircleAvatar(
        child: Text(index.toString()),
      ),
      trailing: Container(
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
            color: cita.estado == "SP" ? Colors.grey : Colors.green,
            borderRadius: BorderRadius.circular(100.0)),
      ),
      onTap: cita.estado == "SP"
          ? null
          : () {
              onJoin(cita.id.toString());
            },
    );
  }

  _cargarCitas() async {
    this.citas = await citaService.getCitasPaciente('V');
    setState(() {});
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Future<void> onJoin(String strIdCita) async {
    // String strIdCita = 'appx1';
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
