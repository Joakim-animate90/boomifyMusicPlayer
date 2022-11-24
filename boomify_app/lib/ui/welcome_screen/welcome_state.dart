part of "welcome_bloc.dart";
abstract class WelcomeState extends Equatable {
  const WelcomeState();
}
class WelcomeStateInitial extends WelcomeState {
  @override
  List<Object> get props => [];
}
class WelcomeStateLoading extends WelcomeState {
  @override
  List<Object> get props => [];
}
class WelcomeStateError extends WelcomeState {
  const WelcomeStateError({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}
class WelcomeStateLogin extends WelcomeState {
  @override
  List<Object> get props => [];
}
class WelcomeStateSignUp extends WelcomeState {
  @override
  List<Object> get props => [];
}

