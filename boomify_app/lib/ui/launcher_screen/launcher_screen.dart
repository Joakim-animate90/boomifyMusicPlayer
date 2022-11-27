import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/helper.dart';
import '../../service_authentication/Authentication_Bloc/authentication_bloc.dart';
import '../../utils/constants.dart';
import '../Onboarding_screen/data.dart';
import '../Onboarding_screen/on_boarding_screen.dart';
import '../welcome_screen/welcome_page.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({Key? key}) : super(key: key);

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationBloc>().add(CheckFirstRunEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(colorPrimary),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case AuthenticationOnBoarding:
              pushReplacement(
                  context,
                  OnBoardingScreen(
                    images: imageList,
                    titles: titlesList,
                    subtitles: subtitlesList,
                  ));
              break;

            case AuthenticationUnauthenticated:
              pushReplacement(context, const WelcomeScreen());
              break;
          }
        },
        child: const Center(
          child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation(Color(colorPrimary)),
          ),
        ),
      ),
    );
  }
}