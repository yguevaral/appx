import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String titulo;

  const Logo({
    Key key,
    @required this.titulo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage('assets/main_logo.jpeg'),
              width: 180.0,
            ),
            SizedBox(height: 20),
            Text(
              this.titulo,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
