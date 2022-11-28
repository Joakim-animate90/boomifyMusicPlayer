part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class RetrieveLostDataEvent extends SignUpEvent {
  const RetrieveLostDataEvent();
  @override
  List<Object> get props => [];
}

class ChooseImageFromGalleryEvent extends SignUpEvent {
  const ChooseImageFromGalleryEvent();

  @override
  List<Object> get props => [];
}

class CaptureImageByCameraEvent extends SignUpEvent {
  const CaptureImageByCameraEvent();
  @override
  List<Object> get props => [];
}

class ValidateFieldsEvent extends SignUpEvent {
  final GlobalKey<FormState> key;
  final bool acceptEula;

  const ValidateFieldsEvent(this.key, {required this.acceptEula});

  @override
  List<Object?> get props => [key, acceptEula];
}

class ToggleEulaCheckboxEvent extends SignUpEvent {
  final bool eulaAccepted;

  const ToggleEulaCheckboxEvent({required this.eulaAccepted});

  @override
  List<Object?> get props => [eulaAccepted];
}
