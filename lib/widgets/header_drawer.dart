
import 'package:flutter/material.dart';

class HeaderDrawer extends StatelessWidget {
  const HeaderDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
        Image(
          image: AssetImage('assets/appbar_logo.png'),
          fit: BoxFit.contain,
          width: 90.0
        )
    );
  }
}