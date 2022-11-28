import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<ValidateLoginFieldsEvent>(_ValidateLoginFieldsEvent);
  }

  void _ValidateLoginFieldsEvent(
      ValidateLoginFieldsEvent event, Emitter<LoginState> emit) {
    if (event.key.currentState!.validate()) {
      event.key.currentState!.save();
      emit(ValidLoginFields());
    } else {
      emit(LoginFailureState(errorMessage: 'Invalid fields'));
    }
  }
}