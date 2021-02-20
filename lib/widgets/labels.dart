import 'package:appx/global/environment.dart';
import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String titulo;
  final String subtitulo;

  const Labels({
    Key key,
    @required this.ruta,
    @required this.titulo,
    @required this.subtitulo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(this.titulo,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w300)),
          SizedBox(height: 10.0),
          GestureDetector(
            child: Text(this.subtitulo,
                style: TextStyle(
                    color: Environment.colorApp1,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pushReplacementNamed(context, this.ruta);
            },
          ),
        ],
      ),
    );
  }
}
