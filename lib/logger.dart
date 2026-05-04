import 'dart:io';

class AppLogger {
  final String filePath;

  AppLogger(this.filePath);

  void log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] $message\n';
    try {
      File(filePath).writeAsStringSync(logEntry, mode: FileMode.append);
    } catch (e) {
      print('Error writing to log: $e');
    }
  }
}
