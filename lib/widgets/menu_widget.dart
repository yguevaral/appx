import 'package:appx/global/environment.dart';
import 'package:appx/helpers/url_navegador.dart';
import 'package:appx/services/auth_service.dart';
import 'package:appx/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';


// import 'package:preferenciasusuarioapp/src/pages/home_page.dart';
// import 'package:preferenciasusuarioapp/src/pages/settings_page.dart';


class MenuWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    final authService = Provider.of<AuthService>(context);


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    child: Image(
                      image: AssetImage('assets/splash_logo.jpeg'),
                      fit: BoxFit.fill,
                      width: 90.0
                    ),
                    backgroundColor: Colors.blue[100],
                    maxRadius: 50,
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    authService.usuario.nombre,
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menu-img.jpg'),
                fit: BoxFit.cover
              )
            ),
          ),

          ListTile(
            leading: Icon( Icons.home, color: Environment.colorApp1 ),
            title: Text('Inicio'),
            onTap: ()=> Navigator.pushReplacementNamed(context, 'home' ) ,
          ),

          ListTile(
            leading: Icon( Icons.functions, color: Environment.colorApp1 ),
            title: Text('Servicios'),
            onTap: () {

              showUrlNavegadorInterno('https://appxguatemala.app/');
            },
          ),

          ListTile(
            leading: Icon( Icons.pages, color: Environment.colorApp1 ),
            title: Text('Noticias saludables'),
            onTap: (){
              showUrlNavegadorInterno('https://appxguatemala.app/');
            },
          ),

          ListTile(
            leading: Icon( Icons.exit_to_app, color: Environment.colorApp1 ),
            title: Text('Salir'),
            onTap: (){
                socketService.disconnect();
                Navigator.pushReplacementNamed(context, 'login');
                AuthService.deleteToken();
            }
          ),

        ],
      ),
    );
  }
}