import 'dart:io';
import 'lib/book.dart';
import 'lib/storage.dart';
import 'lib/book_manager.dart';

void main() async {
  final storage = BookStorage('books.json');
  final manager = BookManager(storage);
  await manager.init();

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
        addBookUI(manager);
        break;
      case 2:
        viewBooksUI(manager);
        break;
      case 3:
        updateBookUI(manager);
        break;
      case 4:
        deleteBookUI(manager);
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

void addBookUI(BookManager manager) {
  print('\n--- Create Book ---');
  stdout.write('Title: ');
  String title = stdin.readLineSync() ?? '';
  stdout.write('Author: ');
  String author = stdin.readLineSync() ?? '';
  stdout.write('Year (number): ');
  String yearInput = stdin.readLineSync() ?? '';
  int year = int.tryParse(yearInput) ?? 0;

  manager.add(Book(title: title, author: author, year: year));
  print('Book registered successfully.\n');
}

void viewBooksUI(BookManager manager) {
  print('\n--- Book List ---');
  final books = manager.books;
  if (books.isEmpty) {
    print('No books registered.');
    return;
  }
  for (int i = 0; i < books.length; i++) {
    print('$i: ${books[i].toString()}');
  }
  print('');
}

void updateBookUI(BookManager manager) {
  if (manager.books.isEmpty) {
    print('No books to edit.');
    return;
  }
  print('\n--- Edit Book ---');
  viewBooksUI(manager);
  stdout.write('Enter the index of the book to update: ');
  int? index = int.tryParse(stdin.readLineSync() ?? '');
  if (index == null) {
    print('Invalid index.');
    return;
  }

  var book = manager.getAt(index);
  if (book == null) {
    print('Book not found.');
    return;
  }

  stdout.write('New title (enter to keep "${book.title}"): ');
  String inputTitle = stdin.readLineSync() ?? '';
  
  stdout.write('New author (enter to keep "${book.author}"): ');
  String inputAuthor = stdin.readLineSync() ?? '';

  stdout.write('New year (enter to keep ${book.year}): ');
  String inputYear = stdin.readLineSync() ?? '';
  int? year = inputYear.trim().isNotEmpty ? int.tryParse(inputYear) : null;

  if (manager.update(index, title: inputTitle, author: inputAuthor, year: year)) {
    print('Book updated successfully.\n');
  } else {
    print('Failed to update book.\n');
  }
}

void deleteBookUI(BookManager manager) {
  if (manager.books.isEmpty) {
    print('No books to delete.');
    return;
  }
  print('\n--- Delete Book ---');
  viewBooksUI(manager);
  stdout.write('Enter the index of the book to delete: ');
  int? index = int.tryParse(stdin.readLineSync() ?? '');
  if (index == null) {
    print('Invalid index.');
    return;
  }

  if (manager.remove(index)) {
    print('Book deleted successfully.\n');
  } else {
    print('Failed to delete book.\n');
  }
}
