class Book {
  final int? id;
  final String title;
  final String author;
  final String? isbn;
  final int? publicationYear; // Добавлено поле
  final int? totalCopies;
  final int? availableCopies;

  Book({
    this.id,
    required this.title,
    required this.author,
    this.isbn,
    this.publicationYear,
    this.totalCopies,
    this.availableCopies,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['book_id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Неизвестное название',
      author: json['author'] as String? ?? 'Неизвестный автор',
      isbn: json['isbn'] as String?,
      publicationYear: json['publication_year'] as int?,
      totalCopies: json['total_copies'] as int? ?? 0,
      availableCopies: json['available_copies'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'book_id': id,
        'title': title,
        'author': author,
        'isbn': isbn,
        'publication_year': publicationYear,
        'total_copies': totalCopies,
        'available_copies': availableCopies,
      };
}