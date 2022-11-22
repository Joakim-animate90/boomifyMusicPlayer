import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthenticationBloc() : super(_firebaseAuth.userChanges().listen((User? user) => {

  }) == null ? AuthenticationUnauthenticated() : AuthenticationAuthenticated(user: _firebaseAuth.currentUser!));



}
