import 'package:appx/global/environment.dart';
import 'package:appx/models/usuario.dart';
import 'package:appx/models/usuarios_response.dart';
import 'package:appx/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final resp = await http.get('${Environment.apiUrl}/usuarios', headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
