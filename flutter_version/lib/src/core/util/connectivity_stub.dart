Future<bool> checkConnection() async {
  // On web we can't use dart:io; assume true (online) to allow regular API calls.
  return true;
}
