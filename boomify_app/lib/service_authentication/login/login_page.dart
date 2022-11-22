
import 'package:boomify_app/service_authentication/utils/page.dart';
import 'package:flutter/material.dart';
import '../../utils/logo.dart';

class LoginPage extends StatelessWidget{
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
         backgroundColor: Colors.white,
        body: Center(
        child:ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            children: const <Widget>[
              Logo(),
              SizedBox(height: 48.0),
              EmailTextField(),
              SizedBox(height: 8.0),
              PassWordField(),
              SizedBox(height: 24.0),
              LoginButton(),
              ForgotLabel(),
            ],
        ),
        ),
      );
  }

}