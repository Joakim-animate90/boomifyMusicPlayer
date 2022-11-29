part of "welcome_bloc.dart";
abstract class WelcomeEvent extends Equatable {
  const WelcomeEvent();
}
class WelcomeEventLogin extends WelcomeEvent {
  @override
  List<Object> get props => [];
}
class WelcomeEventSignUp extends WelcomeEvent {
  @override
  List<Object> get props => [];
}