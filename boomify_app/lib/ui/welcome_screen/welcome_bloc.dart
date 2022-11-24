import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'welcome_event.dart';
part 'welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(WelcomeStateInitial()){
    on<WelcomeEventLogin>(_onWelcomeEventLogin);
    on<WelcomeEventSignUp>(_onWelcomeEventSignUp);
  }
  void _onWelcomeEventLogin(WelcomeEventLogin event, Emitter<WelcomeState> emit) async {
    emit(WelcomeStateLoading());
    try {
      emit(WelcomeStateLogin());
    } catch (e) {
      emit(WelcomeStateError(message: e.toString()));
    }
  }
  void _onWelcomeEventSignUp(WelcomeEventSignUp event, Emitter<WelcomeState> emit) async {
    emit(WelcomeStateLoading());
    try {
      emit(WelcomeStateSignUp());
    } catch (e) {
      emit(WelcomeStateError(message: e.toString()));
    }
  }

}