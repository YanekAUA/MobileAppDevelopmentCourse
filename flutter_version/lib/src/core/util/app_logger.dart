import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 3,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );
}
