import 'book.dart';
import 'storage.dart';

class BookManager {
  final BookStorage _storage;
  List<Book> _books = [];

  BookManager(this._storage);

  List<Book> get books => List.unmodifiable(_books);

  Future<void> init() async {
    _books = await _storage.loadBooks();
  }

  void add(Book book) {
    _books.add(book);
    _save();
  }

  bool update(int index, {String? title, String? author, int? year}) {
    if (index < 0 || index >= _books.length) return false;
    
    if (title != null && title.isNotEmpty) _books[index].title = title;
    if (author != null && author.isNotEmpty) _books[index].author = author;
    if (year != null) _books[index].year = year;
    
    _save();
    return true;
  }

  bool remove(int index) {
    if (index < 0 || index >= _books.length) return false;
    _books.removeAt(index);
    _save();
    return true;
  }

  Book? getAt(int index) {
    if (index < 0 || index >= _books.length) return null;
    return _books[index];
  }

  void _save() {
    _storage.saveBooks(_books);
  }
}
