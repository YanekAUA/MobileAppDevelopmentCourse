// Conditional import: use dart:io based lookup on non-web, and a stub on web.
import 'connectivity_stub.dart' if (dart.library.io) 'connectivity_io.dart';

Future<bool> hasInternetConnection() => checkConnection();
