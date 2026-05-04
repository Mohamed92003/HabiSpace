import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    AppLogger.info(message: 'Created', tag: bloc.runtimeType.toString());
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    AppLogger.debug(
      message: 'State Change: ${change.currentState} → ${change.nextState}',
      tag: bloc.runtimeType.toString(),
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    AppLogger.info(
      message:
          '''
Event : ${transition.event}
From  : ${transition.currentState}
To    : ${transition.nextState}
''',
      tag: bloc.runtimeType.toString(),
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    AppLogger.error(
      message: 'Error: $error',
      stackTrace: stackTrace,
      tag: bloc.runtimeType.toString(),
    );

    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    AppLogger.warning(message: 'Closed', tag: bloc.runtimeType.toString());

    super.onClose(bloc);
  }
}

enum LogLevel { debug, info, warning, error }

class LogConfig {
  static bool enableLogs = !kReleaseMode;
}

class AppLogger {

  static void debug({required String message, String? tag}) {
    _log(message: message, level: LogLevel.debug, tag: tag);
  }

  static void info({required String message, String? tag}) {
    _log(message: message, level: LogLevel.info, tag: tag);
  }

  static void warning({required String message, String? tag}) {
    _log(message: message, level: LogLevel.warning, tag: tag);
  }

  static void error({
    required String message,
    String? tag,
    StackTrace? stackTrace,
  }) {
    _log(
      message: message,
      level: LogLevel.error,
      tag: tag,
      stackTrace: stackTrace,
    );
  }

  static void _log({
    required String message,
    required LogLevel level,
    String? tag,
    StackTrace? stackTrace,
  }) {
    if (!LogConfig.enableLogs) return;

    final time = DateTime.now().toIso8601String();

    final emoji = switch (level) {
      LogLevel.debug => '🐛Loading cubit',
      LogLevel.info => '💡Creating cubit',
      LogLevel.warning => '⚠️ Warning',
      LogLevel.error => '🔥Error',
    };

    final buffer = StringBuffer();

    buffer.writeln(
      '$emoji [$time] [${level.name.toUpperCase()}]${tag != null ? ' [$tag]' : ''}',
    );
    buffer.writeln(message);

    if (stackTrace != null && !kReleaseMode) {
      buffer.writeln('StackTrace:\n$stackTrace');
    }

    buffer.writeln('────────────────────────────────────────────────────────');

    debugPrint(buffer.toString(), wrapWidth: 1024);
  }
}
