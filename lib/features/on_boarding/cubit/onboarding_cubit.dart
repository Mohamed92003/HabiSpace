import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState());

  final PageController pageController = PageController();

  void onPageChanged(int index) {
    emit(state.copyWith(currentIndex: index, isLastPage: index == 2));
  }
}
