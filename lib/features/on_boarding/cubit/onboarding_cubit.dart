import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState());

  final PageController pageController = PageController();

  void onPageChanged(int index) {
    if (index == 2) {
      emit(state.copyWith(isLastPage: true));
    } else {
      emit(state.copyWith(isLastPage: false));
    }
  }

}
