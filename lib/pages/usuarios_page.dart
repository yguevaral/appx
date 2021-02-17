import 'package:appx/models/usuario.dart';
import 'package:appx/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(uid: '1', nombre: 'Maria', email: 'maria@app.com', online: true),
    Usuario(uid: '2', nombre: 'Jose', email: 'jose@app.com', online: false),
    Usuario(uid: '3', nombre: 'Allan', email: 'allan@app.com', online: true),
  ];
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final usuario = authService.usuario;

    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(usuario.nombre, style: TextStyle(color: Colors.black))),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.black,
              onPressed: () {
                // desconectar socket

                Navigator.pushReplacementNamed(context, 'login');
                AuthService.deleteToken();
              },
            ),
            onPressed: () {},
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.check_circle,
                color: Colors.blue[400],
              ),
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          header: WaterDropHeader(
            complete: Icon(Icons.check, color: Colors.blue[400]),
            waterDropColor: Colors.blue[400],
          ),
          child: _listViewUsuarios(),
        ));
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTitle(usuarios[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: usuarios.length,
    );
  }

  ListTile _usuarioListTitle(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(100.0)),
      ),
    );
  }

  _cargarUsuarios() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
