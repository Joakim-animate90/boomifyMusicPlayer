
part of 'authentication_bloc.dart';
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}
class AuthenticationOnBoarding extends AuthenticationState {
  const AuthenticationOnBoarding();
  @override
  List<Object> get props => [];
}
class AuthenticationAuthenticated extends AuthenticationState {
  final User user;
  const AuthenticationAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}
class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}
class AuthenticationLoading extends AuthenticationState {
  @override
  List<Object> get props => [];
}
class AuthenticationError extends AuthenticationState {
  const AuthenticationError({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

