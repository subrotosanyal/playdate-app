import 'package:logging/logging.dart';

class AppLogger {
  // Private constructor for singleton pattern
  AppLogger._internal();

  // Singleton instance
  static final AppLogger _instance = AppLogger._internal();

  // The actual logger
  final Logger _logger = Logger('AppLogger');

  // Factory constructor to return the same instance
  factory AppLogger() {
    return _instance;
  }

  // Logger initialization (called once)
  void init() {
    Logger.root.level = Level.ALL; // Log all levels

    // Customize the logging output format
    Logger.root.onRecord.listen((LogRecord rec) {
      // Add file, method, and line number from stack trace
      final logDetails = _getLogDetails();
      print('${rec.level.name}: ${rec.time}: $logDetails: ${rec.message}');
    });
  }

  // Get the logger instance
  Logger get logger => _logger;

  // Extract file, method, and line number from the stack trace
  String _getLogDetails() {
    final stackTrace = StackTrace.current.toString().split('\n')[2];
    final pattern = RegExp(r'(\w+).dart:(\d+):(\d+)');
    final match = pattern.firstMatch(stackTrace);
    if (match != null) {
      final fileName = match.group(1);
      final lineNumber = match.group(2);
      final columnNumber = match.group(3);
      return '$fileName.dart:$lineNumber:$columnNumber';
    }
    return 'Unknown';
  }
}
