import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/logo.dart';

class LoginPage extends StatelessWidget{
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
         backgroundColor: Colors.white,
        body: Center(
        child:ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: const <Widget>[
              Logo(),
            ],
        ),
        ),
      );
  }

}