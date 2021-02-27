import 'package:appx/global/environment.dart';
import 'package:appx/helpers/mostrar_alerta.dart';
import 'package:appx/models/citas_response.dart';
import 'package:appx/models/usuario.dart';
import 'package:appx/services/auth_service.dart';
import 'package:appx/services/chat_service.dart';
import 'package:appx/services/cita_service.dart';
import 'package:appx/services/socket_service.dart';
import 'package:appx/services/usuarios_service.dart';
import 'package:appx/widgets/header_drawer.dart';
import 'package:appx/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CitasPacientePage extends StatefulWidget {
  @override
  _CitasPacientePageState createState() => _CitasPacientePageState();
}

class _CitasPacientePageState extends State<CitasPacientePage> {
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
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    final socketService = Provider.of<SocketService>(context);

    final argCitas = ModalRoute.of(context).settings.arguments;

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
              Navigator.pushNamed(context, 'cita');
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
              final chatService =
                  Provider.of<ChatService>(context, listen: false);
              var usuario = Usuario();
              usuario.online = false;
              usuario.tipo = 'M';
              usuario.nombre = 'Medico';
              usuario.email = '';
              usuario.uid = cita.usuarioMedico;
              chatService.usuarioPara = usuario;

              Navigator.pushNamed(context, 'chat');
            },
    );
  }

  _cargarCitas() async {
    this.citas = await citaService.getCitasPaciente('C');
    setState(() {});
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
