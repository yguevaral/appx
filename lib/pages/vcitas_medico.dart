import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:appx/global/environment.dart';
import 'package:appx/models/citas_medico_response.dart';
import 'package:appx/pages/call.dart';
import 'package:appx/services/cita_service.dart';
import 'package:appx/services/socket_service.dart';
import 'package:appx/widgets/header_drawer.dart';
import 'package:appx/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VCitasMedicoPage extends StatefulWidget {
  @override
  _VCitasMedicoPage createState() => _VCitasMedicoPage();
}

class _VCitasMedicoPage extends State<VCitasMedicoPage> {
  final citaService = new CitaService();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<MedicoCita> citas = [];
  int _selectedIndex = 1;
  String citaEstado = 'SP';

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
        bottomNavigationBar: _bottomNavigationBar(context),
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
        ));
  }

  ListView _listViewCitas() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTitle(citas[i], i),
      separatorBuilder: (_, i) => Divider(),
      itemCount: citas.length,
    );
  }

  ListTile _usuarioListTitle(MedicoCita cita, int index) {
    index++;
    return ListTile(
      title: Text(cita.usuarioPaciente.nombre),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cita.sintomas,
            overflow: TextOverflow.ellipsis,
          ),
          Text(Environment.convertToAgo(
              DateTime.parse(cita.createdAt.toString()))),
        ],
      ),
      leading: CircleAvatar(
        child: Text(cita.usuarioPaciente.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: 10.0,
        height: 10.0,
        child: Icon(Icons.chevron_right),
      ),
      onTap: () {
        if (cita.estado == "A") {
          onJoin(cita.id.toString());
        } else {
          var arg = {
            'usuarioId': cita.usuarioPaciente.id,
            'usuarioNombre': cita.usuarioPaciente.nombre,
            'usuarioSintomas': cita.sintomas,
            'usuarioEmail': cita.usuarioPaciente.email,
            'citaId': cita.id,
            'backPage': true
          };

          Navigator.pushNamed(context, 'citaPreguntaMedico',
              arguments: jsonEncode(arg));
        }
      },
    );
  }

  _cargarCitas() async {
    this.citas = await citaService.getCitasMedico('V', citaEstado);

    // this.citas = await citaService.getCitasPaciente('C');
    setState(() {});
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: Environment.colorApp1,
          primaryColor: Colors.white,
          textTheme: Theme.of(context)
              .textTheme
              .copyWith(caption: TextStyle(color: Colors.black))),
      child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/iconCita.png')),
                // ignore: deprecated_member_use
                title: Text('Activas')),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/iconCita.png')),
                // ignore: deprecated_member_use
                title: Text('Pendientes')),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onBarTapItem,
          elevation: 5),
    );
  }

  void _onBarTapItem(int index) {
    citaEstado = citaEstado == 'A' ? 'SP' : 'A';

    setState(() {
      _selectedIndex = index;
      _cargarCitas();
    });
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
