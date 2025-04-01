import 'package:biblio/model/book.dart';

class BookInstance {
  final int? id;
  final int? bookId;
  final String? instanceCode;
  final String? status;
  final Book? book;

  BookInstance({
    this.id,
    this.bookId,
    this.instanceCode,
    this.status,
    this.book,
  });

  factory BookInstance.fromJson(Map<String, dynamic> json) {
    return BookInstance(
      id: json['instance_id'] as int? ?? 0, // Значение по умолчанию, если null
      bookId: json['book_id'] as int? ?? 0, // Значение по умолчанию, если null
      instanceCode: json['instance_code'] as String?,
      status: json['status'] as String?,
      book: json['books'] != null ? Book.fromJson(json['books']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'instance_id': id,
        'book_id': bookId,
        'instance_code': instanceCode,
        'status': status,
      };
}

