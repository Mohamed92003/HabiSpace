import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:habispace/core/constants/api_constant.dart';
import 'package:habispace/core/constants/bloc_abserver.dart';
import 'package:habispace/core/constants/dio_helper.dart';
import 'package:habispace/core/constants/secure_storage.dart';
import 'package:habispace/core/router/app_router.dart';
import 'package:habispace/core/theme/app_theme.dart';
import 'package:habispace/core/theme/theme_cubit.dart';
import 'package:habispace/firebase_options.dart';
import 'core/di/get_it.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('🔔 Background message: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _setupFCM();
  } catch (e) {
    debugPrint('⚠️ Firebase initialization failed: $e');
  }

  ScreenUtil.ensureScreenSize;
  await AuthStorage().init();
  Bloc.observer = AppBlocObserver();
  setupLocator();
  DioHelper.init(baseUrl: ApiConstant.baseUrl);

  final initialRoute = _getInitialRoute();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: BlocProvider(
        create: (_) => ThemeCubit()..loadTheme(),
        child: MyApp(initialRoute: initialRoute),
      ),
    ),
  );
}

/// Request notification permission and set up FCM listeners
Future<void> _setupFCM() async {
  final messaging = FirebaseMessaging.instance;

  // Request permission — required on iOS & Android 13+
  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');

  // Print FCM token for backend registration
  final token = await messaging.getToken();
  debugPrint('🔥 FCM Token: $token');

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('📩 Foreground message: ${message.notification?.title}');
  });

  // Handle tap on notification when app is in background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('📬 Opened from notification: ${message.notification?.title}');
  });
}

String _getInitialRoute() {
  final storage = AuthStorage();

  if (storage.isOnboardingComplete != true) {
    return AppRoutes.onBoarding;
  }

  final token = storage.token;
  if (token != null && token.isNotEmpty) {
    return AppRoutes.home;
  }

  return AppRoutes.login;
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(widget.initialRoute);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'HabiSpace',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: themeMode,
              routerConfig: _router,
            );
          },
        );
      },
    );
  }
}
