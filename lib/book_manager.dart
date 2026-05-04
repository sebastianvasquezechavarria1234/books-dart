import 'book.dart';
import 'storage.dart';
import 'logger.dart';

class BookManager {
  final BookStorage _storage;
  final AppLogger? _logger;
  List<Book> _books = [];

  BookManager(this._storage, [this._logger]);

  List<Book> get books => List.unmodifiable(_books);

  Future<void> init() async {
    _books = await _storage.loadBooks();
  }

  void add(Book book) {
    _validateBook(book);
    _books.add(book);
    _logger?.log('Added new book: ${book.title}');
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
    
    _logger?.log('Updated book at index $index: ${_books[index].title}');
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
    final removedBook = _books.removeAt(index);
    _logger?.log('Removed book: ${removedBook.title}');
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

  Map<String, dynamic> getStatistics() {
    if (_books.isEmpty) return {};

    final total = _books.length;
    final newest = _books.reduce((a, b) => a.year > b.year ? a : b);
    final oldest = _books.reduce((a, b) => a.year < b.year ? a : b);

    // Count books per author
    final authorCounts = <String, int>{};
    for (var book in _books) {
      authorCounts[book.author] = (authorCounts[book.author] ?? 0) + 1;
    }
    final topAuthor = authorCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return {
      'total': total,
      'newest': newest,
      'oldest': oldest,
      'topAuthor': topAuthor,
    };
  }

  void _save() {
    _storage.saveBooks(_books);
  }
}
