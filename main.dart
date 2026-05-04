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
    print('2) View All');
    print('3) Edit');
    print('4) Delete');
    print('5) Search');
    print('6) Exit');

    int? option = int.tryParse(stdin.readLineSync() ?? '');
    if (option == null) {
      print('Please enter a valid number (1-6).');
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
        searchBooksUI(manager);
        break;
      case 6:
        continueRunning = false;
        print('Exiting...');
        break;
      default:
        print('Invalid option. Choose between 1 and 6.');
    }
  }
}

void searchBooksUI(BookManager manager) {
  print('\n--- Search Books ---');
  print('1) Search by Title');
  print('2) Search by Author');
  stdout.write('Select an option: ');
  String choice = stdin.readLineSync() ?? '';

  stdout.write('Enter search query: ');
  String query = stdin.readLineSync() ?? '';

  List<Book> results;
  if (choice == '1') {
    results = manager.searchByTitle(query);
  } else if (choice == '2') {
    results = manager.searchByAuthor(query);
  } else {
    print('Invalid search option.');
    return;
  }

  print('\n--- Search Results ---');
  if (results.isEmpty) {
    print('No matches found.');
  } else {
    for (var book in results) {
      print(book.toString());
    }
  }
  print('');
}

void addBookUI(BookManager manager) {
  print('\n--- Create Book ---');
  try {
    stdout.write('Title: ');
    String title = stdin.readLineSync() ?? '';
    stdout.write('Author: ');
    String author = stdin.readLineSync() ?? '';
    stdout.write('Year (number): ');
    String yearInput = stdin.readLineSync() ?? '';
    int? year = int.tryParse(yearInput);

    if (year == null) {
      print('Error: Year must be a valid number.');
      return;
    }

    manager.add(Book(title: title, author: author, year: year));
    print('Book registered successfully.\n');
  } catch (e) {
    print('Error creating book: ${e.toString().replaceFirst('Invalid argument(s): ', '')}');
  }
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
  
  try {
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
    int? year;
    if (inputYear.trim().isNotEmpty) {
      year = int.tryParse(inputYear);
      if (year == null) {
        print('Error: Year must be a valid number.');
        return;
      }
    }

    if (manager.update(index, title: inputTitle, author: inputAuthor, year: year)) {
      print('Book updated successfully.\n');
    } else {
      print('Failed to update book.\n');
    }
  } catch (e) {
    print('Error updating book: ${e.toString().replaceFirst('Invalid argument(s): ', '')}');
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
