part of 'onboarding_cubit.dart';

abstract class OnBoardingState {}

class OnBoardingInitial extends OnBoardingState {
  int currentPageCount;

  OnBoardingInitial(this.currentPageCount);
}