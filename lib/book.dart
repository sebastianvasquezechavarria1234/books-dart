class Book {
  String title;
  String author;
  int year;

  Book({
    required this.title,
    required this.author,
    required this.year,
  });

  // Convert a Book into a Map. The keys must correspond to the names of the 
  // columns in the database (or keys in JSON).
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'year': year,
    };
  }

  // Convert a Map into a Book.
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      year: map['year'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Title: $title, Author: $author, Year: $year';
  }
}
