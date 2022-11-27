import 'package:boomify_app/service_authentication/Authentication_Bloc/authentication_bloc.dart';
import 'package:boomify_app/service_authentication/login/login_page.dart';
import 'package:boomify_app/ui/launcher_screen/launcher_screen.dart';
import 'package:boomify_app/ui/welcome_screen/welcome_bloc.dart';
import 'package:boomify_app/ui/welcome_screen/welcome_page.dart';
import 'package:boomify_app/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();



      runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthenticationBloc>(
        create: (BuildContext context) => AuthenticationBloc()),
    BlocProvider<WelcomeBloc>(create: (BuildContext context) => WelcomeBloc())
  ], child: const MyApp()));

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true

        await Firebase.initializeApp();

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return MaterialApp(
          home: Scaffold(
            body: Container(
              color: Colors.white,
              child: Center(
                  child: Column(
                    children: const [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 25,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Failed to initialise firebase!',
                        style: TextStyle(color: Colors.red, fontSize: 25),
                      ),
                    ],
                  )),
            ),
          ));
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
          snackBarTheme: const SnackBarThemeData(
              contentTextStyle: TextStyle(color: Colors.white)),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: const Color(colorPrimary),
              brightness: Brightness.light),
        ),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.grey.shade800,
            appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.light),
            snackBarTheme: const SnackBarThemeData(
                contentTextStyle: TextStyle(color: Colors.white)),
            colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: const Color(colorPrimary),
                brightness: Brightness.dark)),
        debugShowCheckedModeBanner: false,
        color: const Color(colorPrimary),
        home: const LauncherScreen());
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }
}

