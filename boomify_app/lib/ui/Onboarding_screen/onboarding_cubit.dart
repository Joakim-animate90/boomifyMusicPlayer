import 'package:bloc/bloc.dart';

part 'onBoarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingInitial> {
  OnBoardingCubit() : super(OnBoardingInitial(0));

  onPageChanged(int count) {
    emit(OnBoardingInitial(count));
  }
}