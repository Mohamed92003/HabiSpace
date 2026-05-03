import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/secure_storage.dart';
import '../../core/di/get_it.dart';
import '../../core/router/app_router.dart';
import '../../core/utils/app_color.dart';
import '../../core/utils/app_sizes.dart';
import '../../core/utils/app_texts.dart';
import '../auth/presentation/logic/auth_bloc.dart';
import '../auth/presentation/screens/login_screen.dart';
import '../mainlayout/presentation/ui/main_layout.dart';
import 'cubit/onboarding_cubit.dart';
import 'model/onboarding_model.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  Future<void> _onFinish(BuildContext context) async {
    await SecureStorage().setBool(SecureKeys.onboardingComplete, true);

    if (context.mounted) {
      GoRouter.of(context).go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Builder(
        builder: (context) {
          final controller = context.read<OnboardingCubit>();
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: (int index) {
                      controller.onPageChanged(index);
                    },
                    itemCount: OnboardingModel.onboardingList.length,
                    itemBuilder: (context, index) {
                      final model = OnboardingModel.onboardingList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: AppSizes.h500,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(model.image),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(AppSizes.r16),
                                bottomRight: Radius.circular(AppSizes.r16),
                              ),
                            ),
                          ),
                          SizedBox(height: AppSizes.h48),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: AppSizes.w16),
                            child: Text(
                              AppTexts.onboardingTitle.tr(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.sp20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondBlack,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSizes.h12),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal:AppSizes.w16),
                            child: Text(
                              AppTexts.onboardingDescription.tr(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.sp14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondBlack,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: AppSizes.h18),
                BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          SmoothPageIndicator(
                            controller: controller.pageController,
                            count: OnboardingModel.onboardingList.length,
                            effect: const SlideEffect(dotWidth: 30, dotHeight: 4),
                          ),
                          const Spacer(),
                          FloatingActionButton(
                            onPressed: () {
                              controller.pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            heroTag: "back",
                            mini: true,
                            elevation: 0,
                            backgroundColor: AppColors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizes.r30),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_outlined,
                              size: AppSizes.w18,
                              color: AppColors.light,
                            ),
                          ),
                          SizedBox(width: AppSizes.w4),
                          Visibility(
                            visible: state.isLastPage ? false : true,
                            child: FloatingActionButton(
                              onPressed: () {
                                controller.pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              heroTag: "forward",
                              mini: true,
                              elevation: 0,
                              backgroundColor: AppColors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSizes.r30),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: AppSizes.w18,
                                  color: AppColors.light,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: AppSizes.h30),
                BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        if (!state.isLastPage) {
                          controller.pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _onFinish(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.r16),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.w150,
                          vertical: AppSizes.h16,
                        ),
                      ),
                      child: Text(
                        state.isLastPage ? AppTexts.onboardingContinue.tr() : AppTexts.onboardingNext.tr(),
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.sp16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.light,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: AppSizes.h40),
              ],
            ),
          );
        },
      ),
    );
  }
}
