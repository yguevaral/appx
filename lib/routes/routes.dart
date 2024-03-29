import 'package:appx/pages/chat_page.dart';
import 'package:appx/pages/cita_page.dart';
import 'package:appx/pages/cita_pago_page.dart';
import 'package:appx/pages/cita_pregunta_medico_page.dart';
import 'package:appx/pages/citas_medico.dart';
import 'package:appx/pages/citas_paciente.dart';
import 'package:appx/pages/empezar_page.dart';
import 'package:appx/pages/empezar_seleccion_page.dart';
import 'package:appx/pages/espera_cita.dart';
import 'package:appx/pages/home_page.dart';
import 'package:appx/pages/loading_page.dart';
import 'package:appx/pages/login_page.dart';
import 'package:appx/pages/register_page.dart';
import 'package:appx/pages/usuarios_page.dart';
import 'package:flutter/cupertino.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios' : (_) => UsuariosPage(),
  'chat' : (_) => ChatPage(),
  'login' : (_) => LoginPage(),
  'register' : (_) => RegisterPage(),
  'loading' : (_) => LoadingPage(),
  'home' : (_) => HomePage(),
  'cita' : (_) => CitaPage(),
  'citasPaciente' : (_) => CitasPacientePage(),
  'esperarCita' : (_) => EsperarCitaPage(),
  'citaPreguntaMedico' : (_) => CitaPreguntaMedicoPage(),
  'citasMedico' : (_) => CitasMedicoPage(),
  'citaPago' : (_) => CitaPagoPage(),
  'empezar' : (_) => EmpezarPage(),
  'empezarSeleccion' : (_) => EmpezarSeleccionPage()
};
