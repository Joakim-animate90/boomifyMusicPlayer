import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  ImagePicker imagePicker = ImagePicker();
  SignUpBloc() : super(const SignUpInitial()) {
    on<RetrieveLostDataEvent>(_RetrieveLostDataEvent);
    on<ChooseImageFromGalleryEvent>(_ChooseImageFromGalleryEvent);
    on<CaptureImageByCameraEvent>(_CaptureImageByCameraEvent);
    on<ValidateFieldsEvent>(_ValidateFieldsEvent);
    on<ToggleEulaCheckboxEvent>(_ToggleEulaCheckboxEvent);
  }
  void _RetrieveLostDataEvent(
      RetrieveLostDataEvent event, Emitter<SignUpState> emit) async {
    try {
      emit(const SignUpLoadingState());
      final LostDataResponse response = await imagePicker.retrieveLostData();
      if (response.isEmpty) {
        return;
      }
      if (response.file != null) {
        emit(
            SignUpImageSelected(imageData: await response.file!.readAsBytes()));
      } else {
        emit(const SignUpError(errorMessage: 'No image was selected'));
      }
    } catch (e) {
      emit(SignUpError(errorMessage: e.toString()));
    }
  }
  void _ChooseImageFromGalleryEvent(
      ChooseImageFromGalleryEvent event, Emitter<SignUpState> emit) async {
    try {
      emit(const SignUpLoadingState());
      final XFile? image = await imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      if (image != null) {
        emit(SignUpImageSelected(imageData: await image.readAsBytes()));
      } else {
        emit(const SignUpError(errorMessage: 'No image was selected'));
      }
    } catch (e) {
      emit(SignUpError(errorMessage: e.toString()));
    }
  }
  void _CaptureImageByCameraEvent(
      CaptureImageByCameraEvent event, Emitter<SignUpState> emit) async {
    try {
      emit(const SignUpLoadingState());
      final XFile? image = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 50);
      if (image != null) {
        emit(SignUpImageSelected(imageData: await image.readAsBytes()));
      } else {
        emit(const SignUpError(errorMessage: 'No image was selected'));
      }
    } catch (e) {
      emit(SignUpError(errorMessage: e.toString()));
    }
  }
  void _ValidateFieldsEvent(
      ValidateFieldsEvent event, Emitter<SignUpState> emit) async {
    if (event.key.currentState!.validate() && event.acceptEula) {
      emit(const ValidFields());
    } else {
      emit(const SignUpError(errorMessage: 'Please fill all fields'));
    }
  }
  void _ToggleEulaCheckboxEvent(
      ToggleEulaCheckboxEvent event, Emitter<SignUpState> emit) async {
    emit(EulaToggleState(event.eulaAccepted));
  }
}
