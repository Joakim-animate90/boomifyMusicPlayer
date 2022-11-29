import 'dart:typed_data';
import 'package:boomify_app/service_authentication/Authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  User? user;

  late SharedPreferences prefs;
  late bool finishedOnBoarding;
  AuthenticationBloc() : super(AuthenticationLoading()){
    on<CheckFirstRunEvent>(_checkFirstRun);
    on<LogInWithEmailAndPasswordEvent>(_onLogInWithEmailAndPasswordEvent);
    on<SignUpWithEmailAndPasswordEvent>(_onSignUpWithEmailAndPasswordEvent);
    on<FinishedOnBoardingEvent>(_onFinishedOnBoardingEvent);
    on<LogoutRequested>(_onLogoutRequested);
  }
  void _checkFirstRun(CheckFirstRunEvent event, Emitter<AuthenticationState> emit) async {
    prefs = await SharedPreferences.getInstance();
    finishedOnBoarding = prefs.getBool('finishedOnBoarding') ?? false;
    if (!finishedOnBoarding) {
      emit(const AuthenticationOnBoarding());
    } else {
      user = await FireStoreUtils.geAuthUser();
      if (user != null) {
        emit(AuthenticationAuthenticated(user: user!));
      } else {
        emit(AuthenticationUnauthenticated());
      }

    }
  }
  void _onLogInWithEmailAndPasswordEvent(LogInWithEmailAndPasswordEvent event, Emitter<AuthenticationState> emit) async {
    try {
     // emit(AuthenticationLoading());
      print('email: ${event.email} password: ${event.password}');
      dynamic result = await FireStoreUtils.loginWithEmailAndPassword(event.email, event.password);
      print('result: $result');
      if (result != null && result is User) {
        user = result;
        print('user: ${user!.toJson()}');
        emit(AuthenticationAuthenticated(user: user!));
        print('user: ${user!.toJson()}');
      } else {
        emit(const AuthenticationError(message: 'Invalid email or password'));
      }


    } catch (e) {
      emit(AuthenticationError(message: e.toString()));
    }
  }
  void _onSignUpWithEmailAndPasswordEvent(SignUpWithEmailAndPasswordEvent event, Emitter<AuthenticationState> emit) async {
    try {
      //emit(AuthenticationLoading());
      print('email: ${event.email} password: ${event.password}');
      dynamic result = await FireStoreUtils.signUpWithEmailAndPassword(password:event.password, emailAddress: event.email, firstName: event.firstName, lastName: event.lastName);
      print('result: $result');
      if (result != null && result is User) {
        user = result;
        emit(AuthenticationAuthenticated(user: user!));
      }else if(result != null && result is String) {
        emit(AuthenticationError(message: result));
      }
      else {
        emit(const AuthenticationError(message: 'Login failed'));
      }


    } catch (e) {
      emit(AuthenticationError(message: e.toString()));
    }
  }
  void _onFinishedOnBoardingEvent(FinishedOnBoardingEvent event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLoading());
      prefs = await SharedPreferences.getInstance();
      prefs.setBool('finishedOnBoarding', true);
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(AuthenticationError(message: e.toString()));
    }

  }
  void _onLogoutRequested(LogoutRequested event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLoading());
      await FireStoreUtils.signOut();
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(AuthenticationError(message: e.toString()));
    }

  }


}
