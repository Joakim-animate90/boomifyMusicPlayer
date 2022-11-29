part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();
}



class SignUpInitial extends SignUpState {
  const SignUpInitial();
  @override

  List<Object?> get props => [];
}

class SignUpImageSelected extends SignUpState {
  final Uint8List? imageData;

  const SignUpImageSelected({required this.imageData});

  @override

  List<Object?> get props => [imageData];
}
class SignUpLoadingState extends SignUpState {
  const SignUpLoadingState();
  @override

  List<Object?> get props => [];
}
class SignUpError extends SignUpState {
  final String errorMessage;

  const SignUpError({required this.errorMessage});

  @override

  List<Object?> get props => [errorMessage];
}

class ValidFields extends SignUpState {
  const ValidFields();
  @override

  List<Object?> get props => [];
}

class EulaToggleState extends SignUpState {
  bool eulaAccepted;

  EulaToggleState(this.eulaAccepted);

  @override

  List<Object?> get props => [eulaAccepted];
}