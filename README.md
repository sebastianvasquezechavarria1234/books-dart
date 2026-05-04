# 📚 Books Dart CRUD

A robust and professional Book Management System built with Dart CLI.

## 🚀 Overview

This project is a high-quality Command Line Interface (CLI) application designed with clean architecture principles and Object-Oriented Programming (OOP). It provides a complete solution for managing a personal book library with real-time data persistence and advanced analytical tools.

## ✨ Key Features

*   **Full CRUD Operations**: Create, view, update, and delete books with a user-friendly interface.
*   **Data Persistence**: Uses a JSON-based storage engine to ensure your data is saved permanently.
*   **Advanced Search & Filtering**: Quickly find books by title or author with case-insensitive search logic.
*   **Dynamic Sorting**: Sort your collection by Title, Author, or Year in both ascending and descending orders.
*   **Library Dashboard**: Generate instant statistics, including newest/oldest books and most frequent authors.
*   **Audit Logging**: Every action is recorded in an `app.log` file for tracking and debugging.
*   **Robust Validation**: Built-in logic to prevent invalid data entries (e.g., empty titles or future publication years).
*   **Unit Testing**: Core business logic is fully covered by unit tests to guarantee reliability.

## 🛠️ Architecture

The project follows a modular structure to ensure maintainability:
*   `lib/models/`: Data structures (POO).
*   `lib/services/`: Business logic and data management.
*   `lib/persistence/`: File I/O operations.
*   `test/`: Unit testing suite.

## 🚦 Getting Started

1. Ensure you have the [Dart SDK](https://dart.dev/get-dart) installed.
2. Clone the repository.
3. Run the application:
   ```bash
   dart main.dart
   ```
4. Run tests:
   ```bash
   dart test test/book_manager_test.dart
   ```

---
Developed with ❤️ by [Sebastian Vasquez](https://github.com/sebastianvasquezechavarria1234)
