import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/logic/auth_bloc.dart';
import '../../features/auth/presentation/screens/forget_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/forget_password/otp_screen.dart';
import '../../features/auth/presentation/forget_password/reset_password_screen.dart';
import '../../features/chat/presentation/cubit/chat_cubit.dart';
import '../../features/chat/presentation/ui/chat_view.dart';
import '../../features/favorite/domain/entities/favorite_property_entity.dart';
import '../../features/favorite/presentation/cubit/FavoriteCubit/favorite_cubit_cubit.dart';
import '../../features/favorite/presentation/pages/favorite_details_page.dart';
import '../../features/favorite/presentation/pages/favoriteMainPage.dart';
import '../../features/History/presentation/Cubit/cubit/history_cubit.dart';
import '../../features/home/domain/entities/home_property_entity.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/widgets/all_properties_page.dart';
import '../../features/mainlayout/presentation/ui/main_layout.dart';
import '../../features/notifications/presentation/ui/notification_view.dart';
import '../../features/on_boarding/on_boarding.dart';
import '../../features/profile/presentation/Cubit/cubit/profile_cubit.dart';
import '../di/get_it.dart';
part 'app_routes.dart';



GoRouter createRouter(String initialLocation) => GoRouter(
  initialLocation: initialLocation,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.onBoarding,
      name: AppRoutes.onBoarding,
      builder: (context, state) => const OnBoarding(),
    ),

    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (context, state) => BlocProvider<AuthBloc>(
        create: (_) => sl<AuthBloc>(),
        child: LoginScreen(),
      ),
    ),

    GoRoute(
      path: AppRoutes.signup,
      name: AppRoutes.signup,
      builder: (context, state) => BlocProvider<AuthBloc>(
        create: (_) => sl<AuthBloc>(),
        child: SignupScreen(),
      ),
    ),

    GoRoute(
      path: AppRoutes.forgotPassword,
      name: AppRoutes.forgotPassword,
      builder: (context, state) => BlocProvider<AuthBloc>(
        create: (_) => sl<AuthBloc>(),
        child: ForgetPasswordScreen(),
      ),
    ),

    GoRoute(
      path: AppRoutes.otp,
      name: AppRoutes.otp,
      builder: (context, state) {
        final email = state.extra as String;
        return BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
          child: OtpScreen(email: email),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.resetPassword,
      name: AppRoutes.resetPassword,
      builder: (context, state) {
        final args = state.extra as Map<String, String>;
        return BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
          child: ResetPasswordScreen(email: args['email']!, otp: args['otp']!),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(create: (_) => sl<HomeCubit>()..getHome()),
          BlocProvider<FavoriteCubit>(
            create: (_) => sl<FavoriteCubit>()..getFavorites(),
          ),
          BlocProvider<HistoryCubit>(create: (_) => sl<HistoryCubit>()),
          BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>()),
        ],
        child: const MainLayout(),
      ),
    ),

    GoRoute(
      path: AppRoutes.notifications,
      name: AppRoutes.notifications,
      builder: (context, state) => const NotificationView(),
    ),

    GoRoute(
      path: AppRoutes.chat,
      name: AppRoutes.chat,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return BlocProvider(
          create: (_) => sl<ChatCubit>(),
          child: ChatView(
            conversationId: extra['conversationId'] as int,
            agentName: extra['agentName'] as String,
          ),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.allProperties,
      name: AppRoutes.allProperties,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return AllPropertiesPage(
          title: extra['title'] as String,
          properties: extra['properties'] as List<HomePropertyEntity>,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.favoriteBody,
      name: AppRoutes.favoriteBody,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final favoriteCubit = extra['favoriteCubit'] as FavoriteCubit;
        return BlocProvider.value(
          value: favoriteCubit,
          child: FavoriteBody(
            categoryFilter: extra['categoryFilter'] as String?,
          ),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.favoriteDetails,
      name: AppRoutes.favoriteDetails,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final favoriteCubit = extra['favoriteCubit'] as FavoriteCubit;
        return BlocProvider.value(
          value: favoriteCubit,
          child: FavoriteDetailsPage(
            property: extra['property'] as FavoritePropertyEntity,
            allFavorites:
            extra['allFavorites'] as List<FavoritePropertyEntity>? ??
                const [],
          ),
        );
      },
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('${'pageNotFound'.tr()}: ${state.error}')),
  ),
);