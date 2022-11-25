import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthenticationBloc() : super(AuthenticationLoading()){
    on<LogInWithEmailAndPasswordEvent>(_onLogInWithEmailAndPasswordEvent);
    on<SignUpWithEmailAndPasswordEvent>(_onSignUpWithEmailAndPasswordEvent);
    on<LogoutRequested>(_onLogoutRequested);
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
  void _onLogoutRequested(LogoutRequested event, Emitter<AuthenticationState> emit) async {
    await _firebaseAuth.signOut();
    emit(AuthenticationUnauthenticated());
  }


}
