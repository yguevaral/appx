import 'package:appx/global/environment.dart';
import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String text;
  final Function onPressed;

  const BotonAzul({Key key, @required this.text, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {


    return RaisedButton(
      elevation: 2.0,
      highlightElevation: 5.0,
      color: Environment.colorApp1,
      shape: StadiumBorder(),
      padding: EdgeInsets.all(0),
      onPressed: this.onPressed,
      child: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [
          //     Environment.colorApp1,
          //     Color.fromRGBO(95, 161, 205, 1.0),
          //     Color.fromRGBO(165, 221, 235, 1.0),
          //   ],
          // ),
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        width: double.infinity,
        height: 55.0,
        child: Center(
          child: Text(
            this.text,
            style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
