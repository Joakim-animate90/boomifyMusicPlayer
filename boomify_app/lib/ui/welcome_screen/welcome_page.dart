import 'package:boomify_app/ui/welcome_screen/welcome_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/helper.dart';
import '../../service_authentication/login/login_page.dart';
import '../../service_authentication/sign_up/signUp_page.dart';
import '../../utils/constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<WelcomeBloc, WelcomeState>(listener: (context, state) {
      switch (state.runtimeType) {
        case WelcomeStateLogin:
          push(context, const LoginScreen());
          break;
        case WelcomeStateSignUp:
          push(context, const SignUpScreen());
          break;
        default:
          break;
      }
    }, child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Image.asset(
            'assets/images/welcome_image.png',
            width: 150.0,
            height: 150.0,
            fit: BoxFit.cover,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
              left: 16, top: 32, right: 16, bottom: 8),
          child: Text(
            'Say Hello To Your New App!',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(colorPrimary),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          child: Text(
            'You\'ve just saved a week of development and headaches.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromWidth(
                  MediaQuery.of(context).size.width / 1.5),
              backgroundColor: const Color(colorPrimary),
              textStyle: const TextStyle(color: Colors.white),
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: const BorderSide(color: Color(colorPrimary))),
            ),
            child: const Text(
              'Log In',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              context.read<WelcomeBloc>().add(WelcomeEventLogin());
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              right: 40.0, left: 40.0, top: 20, bottom: 20),
          child: TextButton(
            onPressed: () {
              context.read<WelcomeBloc>().add(WelcomeEventSignUp());
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              fixedSize: Size.fromWidth(
                  MediaQuery.of(context).size.width / 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: const BorderSide(
                  color: Color(colorPrimary),
                ),
              ),
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(colorPrimary)),
            ),
          ),
        )
      ],
    ),


    );
  }
}