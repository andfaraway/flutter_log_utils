import 'dart:convert';
import 'dart:developer' as dev;

class Log {
  const Log._();

  static init({
    bool apiLogOpen = true,
    String defaultTag = 'LOG',
    bool expandLog = false,
  }) {
    Log.apiLogOpen = apiLogOpen;
    Log.defaultTag = defaultTag;
    Log.expandLog = expandLog;
  }

  static bool apiLogOpen = true;

  static String defaultTag = 'log';

  static bool expandLog = false;

  static int lineSeparatorLength = 160;

  static void line({
    String separator = '=',
    int? length,
    String tag = '',
    int spaceLine = 0,
  }) {
    String text = separator * (length ?? lineSeparatorLength) + '\n' * spaceLine;
    dev.log(text, name: tag);
  }

  static void i(
    dynamic message, {
    String? tag,
    StackTrace? stackTrace,
    bool? expand,
  }) {
    _printLog(
      message,
      '${tag ?? defaultTag} ❕',
      stackTrace,
      expand: expand,
    );
  }

  static void d(
    dynamic message, {
    String? tag,
    StackTrace? stackTrace,
    bool? expand,
  }) {
    _printLog(
      message,
      '${tag ?? defaultTag} 🐛',
      stackTrace,
      expand: expand,
    );
  }

  static void n(
    dynamic message, {
    String? tag,
    StackTrace? stackTrace,
    int? level,
    bool? expand,
  }) {
    if (apiLogOpen) {
      _printLog(
        message,
        '🌐 ${tag ?? 'network'}',
        stackTrace,
        level: level,
        expand: expand,
      );
    }
  }

  static void w(
    dynamic message, {
    String? tag,
    StackTrace? stackTrace,
    bool? expand,
  }) {
    _printLog(
      message,
      '${tag ?? defaultTag} ⚠️',
      stackTrace,
      expand: expand,
    );
  }

  static void e(
    dynamic message, {
    String? tag,
    StackTrace? stackTrace,
    bool withStackTrace = true,
    bool isError = true,
    int? level,
  }) {
    _printLog(
      message,
      '${tag ?? defaultTag} ❌',
      stackTrace,
      level: level ?? 800,
      isError: isError,
      withStackTrace: withStackTrace,
    );
  }

  static void _printLog(
    dynamic message,
    String? tag,
    StackTrace? stackTrace, {
    bool isError = false,
    int? level,
    bool withStackTrace = true,
    bool? expand,
  }) {
    dev.log(
      '${_timeDateFormat(DateTime.now())} ${expand ?? expandLog ? '\n' : ''}${_messageFormat(message)}',
      time: DateTime.now(),
      name: tag ?? defaultTag,
      level: level ?? 800,
      stackTrace: stackTrace ?? (isError && withStackTrace ? StackTrace.current : null),
    );
  }

  static dynamic _messageFormat(dynamic message) {
    try {
      if (expandLog) {
        return const JsonEncoder.withIndent(' ').convert(message);
      } else {
        return jsonEncode(message);
      }
    } catch (e) {
      return message;
    }
  }

  static String _timeDateFormat(DateTime dateTime) {
    String intToTwoString(int number) {
      return number.toString().padLeft(2, '0');
    }

    return '[${intToTwoString(dateTime.hour)}:${intToTwoString(dateTime.minute)}:${intToTwoString(dateTime.second)}:${intToTwoString(dateTime.millisecond)}]';
  }
}
