import 'package:test/test.dart';
import '../lib/book.dart';
import '../lib/book_manager.dart';
import '../lib/storage.dart';

class MockStorage extends BookStorage {
  MockStorage() : super('test_books.json');
  
  @override
  Future<void> saveBooks(List<Book> books) async {}
  
  @override
  Future<List<Book>> loadBooks() async => [];
}

void main() {
  group('BookManager Tests', () {
    late BookManager manager;

    setUp(() {
      manager = BookManager(MockStorage());
    });

    test('Adding a book increases the count', () {
      manager.add(Book(title: 'Test Book', author: 'Author', year: 2020));
      expect(manager.books.length, 1);
      expect(manager.books.first.title, 'Test Book');
    });

    test('Updating a book changes its values', () {
      manager.add(Book(title: 'Old Title', author: 'Author', year: 2020));
      manager.update(0, title: 'New Title');
      expect(manager.books.first.title, 'New Title');
    });

    test('Removing a book decreases the count', () {
      manager.add(Book(title: 'Book to Delete', author: 'Author', year: 2020));
      manager.remove(0);
      expect(manager.books.isEmpty, true);
    });

    test('Validation throws error for empty title', () {
      expect(
        () => manager.add(Book(title: '', author: 'Author', year: 2020)),
        throwsArgumentError,
      );
    });
  });
}
