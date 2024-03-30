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

  static void line(String lineSpace, {
    int length = 160,
    String tag = '',
    int spaceLine = 0,
  }) {
    String text = lineSpace * length + '\n' * spaceLine;
    dev.log(text, name: tag);
  }

  static void i(dynamic message, {
    String? tag,
    StackTrace? stackTrace,
  }) {
    _printLog(message, '${tag ?? defaultTag} ❕', stackTrace);
  }

  static void d(dynamic message, {
    String? tag,
    StackTrace? stackTrace,
  }) {
    _printLog(message, '${tag ?? defaultTag} 🐛', stackTrace);
  }

  static void n(dynamic message, {
    String? tag,
    StackTrace? stackTrace, int? level,

  }) {
    if (apiLogOpen) {
      if (message == null) return;
      try {
        if (message.isEmpty) {
          return;
        }
      } catch (_) {
        return;
      }
      _printLog(message, '🌐 ${tag ?? 'network'}', stackTrace, level: level);
    }
  }

  static void w(dynamic message, {String? tag, StackTrace? stackTrace}) {
    _printLog(
      message,
      '${tag ?? defaultTag} ⚠️',
      stackTrace,
    );
  }

  static void e(dynamic message, {
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

  static void _printLog(dynamic message,
      String? tag,
      StackTrace? stackTrace,
      {
        bool isError = false,
        int? level,
        bool withStackTrace = true,
      }) {
    dev.log(
      '${_timeDateFormat(DateTime.now())} ${expandLog ? '\n' : ''}${_messageFormat(message)}',
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

    return '[${intToTwoString(dateTime.hour)}:${intToTwoString(dateTime.minute)}:${intToTwoString(
        dateTime.second)}:${intToTwoString(dateTime.millisecond)}]';
  }
}
