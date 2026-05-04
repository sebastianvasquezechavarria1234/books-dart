import 'dart:convert';
import 'dart:io';
import 'book.dart';

class BookStorage {
  final String filePath;

  BookStorage(this.filePath);

  Future<void> saveBooks(List<Book> books) async {
    try {
      final List<Map<String, dynamic>> jsonList = books.map((b) => b.toMap()).toList();
      final String jsonString = jsonEncode(jsonList);
      final File file = File(filePath);
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving books: $e');
    }
  }

  Future<List<Book>> loadBooks() async {
    try {
      final File file = File(filePath);
      if (!await file.exists()) {
        return [];
      }
      final String jsonString = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) => Book.fromMap(item)).toList();
    } catch (e) {
      print('Error loading books: $e');
      return [];
    }
  }
}
