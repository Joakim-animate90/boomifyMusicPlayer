part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class LogoutRequested extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class LogInWithEmailAndPasswordEvent extends AuthenticationEvent {

  const LogInWithEmailAndPasswordEvent({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
class SignUpWithEmailAndPasswordEvent extends AuthenticationEvent {

  const SignUpWithEmailAndPasswordEvent({required this.email, required this.password, required this.firstName, required this.lastName, required this.imageData});

  final String email;
  final String password;
  final Uint8List imageData;
  final String firstName;
  final String lastName;

  @override
  List<Object> get props => [email, password, imageData, firstName, lastName];
}