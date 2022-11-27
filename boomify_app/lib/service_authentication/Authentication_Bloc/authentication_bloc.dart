import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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
      if (_firebaseAuth.currentUser != null) {
        emit(AuthenticationAuthenticated(user: _firebaseAuth.currentUser));
      } else {
        emit(AuthenticationUnauthenticated());
      }

    }
  }
  void _onLogInWithEmailAndPasswordEvent(LogInWithEmailAndPasswordEvent event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLoading());
      await _firebaseAuth.signInWithEmailAndPassword(email: event.email, password: event.password);
      emit(AuthenticationAuthenticated(user: _firebaseAuth.currentUser));
    } catch (e) {
      emit(AuthenticationError(message: e.toString()));
    }
  }
  void _onSignUpWithEmailAndPasswordEvent(SignUpWithEmailAndPasswordEvent event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLoading());
      await _firebaseAuth.createUserWithEmailAndPassword(email: event.email, password: event.password);
      emit(AuthenticationAuthenticated(user: _firebaseAuth.currentUser));
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
    await _firebaseAuth.signOut();
    emit(AuthenticationUnauthenticated());
  }


}
