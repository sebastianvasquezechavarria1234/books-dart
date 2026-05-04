import 'dart:io';
import 'lib/book.dart';
import 'lib/storage.dart';

void main() async {
  final storage = BookStorage('books.json');
  List<Book> books = await storage.loadBooks();

  print('===== WELCOME TO THE BOOK CRUD =====');

  bool continueRunning = true;
  while (continueRunning) {
    print('Select an option:');
    print('1) Create');
    print('2) View');
    print('3) Edit');
    print('4) Delete');
    print('5) Exit');

    int? option = int.tryParse(stdin.readLineSync() ?? '');
    if (option == null) {
      print('Please enter a valid number (1-5).');
      continue;
    }

    switch (option) {
      case 1:
        addBook(books);
        await storage.saveBooks(books);
        break;
      case 2:
        viewBooks(books);
        break;
      case 3:
        updateBook(books);
        await storage.saveBooks(books);
        break;
      case 4:
        deleteBook(books);
        await storage.saveBooks(books);
        break;
      case 5:
        continueRunning = false;
        print('Exiting...');
        break;
      default:
        print('Invalid option. Choose between 1 and 5.');
    }
  }
}

void addBook(List<Book> books) {
  print('\n--- Create Book ---');
  stdout.write('Title: ');
  String title = stdin.readLineSync() ?? '';
  stdout.write('Author: ');
  String author = stdin.readLineSync() ?? '';
  stdout.write('Year (number): ');
  String yearInput = stdin.readLineSync() ?? '';
  int year = int.tryParse(yearInput) ?? 0;

  books.add(Book(title: title, author: author, year: year));
  print('Book registered successfully.\n');
}

void viewBooks(List<Book> books) {
  print('\n--- Book List ---');
  if (books.isEmpty) {
    print('No books registered.');
    return;
  }
  for (int i = 0; i < books.length; i++) {
    print('$i: ${books[i].toString()}');
  }
  print('');
}

void updateBook(List<Book> books) {
  if (books.isEmpty) {
    print('No books to edit.');
    return;
  }
  print('\n--- Edit Book ---');
  viewBooks(books);
  stdout.write('Enter the index of the book to update: ');
  int? index = int.tryParse(stdin.readLineSync() ?? '');
  if (index == null || index < 0 || index >= books.length) {
    print('Invalid index.');
    return;
  }

  var book = books[index];

  stdout.write('New title (enter to keep "${book.title}"): ');
  String inputTitle = stdin.readLineSync() ?? '';
  if (inputTitle.trim().isNotEmpty) book.title = inputTitle.trim();

  stdout.write('New author (enter to keep "${book.author}"): ');
  String inputAuthor = stdin.readLineSync() ?? '';
  if (inputAuthor.trim().isNotEmpty) book.author = inputAuthor.trim();

  stdout.write('New year (enter to keep ${book.year}): ');
  String inputYear = stdin.readLineSync() ?? '';
  if (inputYear.trim().isNotEmpty) {
    book.year = int.tryParse(inputYear) ?? book.year;
  }

  print('Book updated successfully.\n');
}

void deleteBook(List<Book> books) {
  if (books.isEmpty) {
    print('No books to delete.');
    return;
  }
  print('\n--- Delete Book ---');
  viewBooks(books);
  stdout.write('Enter the index of the book to delete: ');
  int? index = int.tryParse(stdin.readLineSync() ?? '');
  if (index == null || index < 0 || index >= books.length) {
    print('Invalid index.');
    return;
  }

  books.removeAt(index);
  print('Book deleted successfully.\n');
}
