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
    _validateBook(book);
    _books.add(book);
    _save();
  }

  bool update(int index, {String? title, String? author, int? year}) {
    if (index < 0 || index >= _books.length) return false;
    
    if (title != null && title.trim().isNotEmpty) {
      _books[index].title = title.trim();
    }
    if (author != null && author.trim().isNotEmpty) {
      _books[index].author = author.trim();
    }
    if (year != null) {
      if (year < 0 || year > DateTime.now().year + 5) {
        throw ArgumentError('Invalid year: $year');
      }
      _books[index].year = year;
    }
    
    _save();
    return true;
  }

  void _validateBook(Book book) {
    if (book.title.trim().isEmpty) throw ArgumentError('Title cannot be empty');
    if (book.author.trim().isEmpty) throw ArgumentError('Author cannot be empty');
    if (book.year < 0 || book.year > DateTime.now().year + 5) {
      throw ArgumentError('Invalid year: ${book.year}');
    }
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

  List<Book> searchByTitle(String query) {
    final lowerQuery = query.toLowerCase();
    return _books.where((b) => b.title.toLowerCase().contains(lowerQuery)).toList();
  }

  List<Book> searchByAuthor(String query) {
    final lowerQuery = query.toLowerCase();
    return _books.where((b) => b.author.toLowerCase().contains(lowerQuery)).toList();
  }

  void sortBy(String criteria, {bool ascending = true}) {
    int Function(Book, Book) comparator;

    switch (criteria.toLowerCase()) {
      case 'title':
        comparator = (a, b) => a.title.compareTo(b.title);
        break;
      case 'author':
        comparator = (a, b) => a.author.compareTo(b.author);
        break;
      case 'year':
        comparator = (a, b) => a.year.compareTo(b.year);
        break;
      default:
        return;
    }

    _books.sort(comparator);
    if (!ascending) {
      _books = _books.reversed.toList();
    }
    _save();
  }

  void _save() {
    _storage.saveBooks(_books);
  }
}
