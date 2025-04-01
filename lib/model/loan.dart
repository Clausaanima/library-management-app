import 'package:biblio/model/book_instance.dart';
import 'package:biblio/model/reader.dart';

class Loan {
  final int? id;
  final int? instanceId;
  final int? readerId;
  final DateTime? issueDate;
  final DateTime? dueDate;
  final DateTime? returnDate;
  final BookInstance? bookInstance;
  final Reader? reader;

  Loan({
    this.id,
    this.instanceId,
    this.readerId,
    this.issueDate,
    this.dueDate,
    this.returnDate,
    this.bookInstance,
    this.reader,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['loan_id'] as int? ?? 0,
      instanceId: json['instance_id'] as int? ?? 0,
      readerId: json['reader_id'] as int? ?? 0,
      issueDate: json['issue_date'] != null ? DateTime.parse(json['issue_date']) : null,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      returnDate: json['return_date'] != null ? DateTime.parse(json['return_date']) : null,
      bookInstance: json['book_instances'] != null ? BookInstance.fromJson(json['book_instances']) : null,
      reader: json['readers'] != null ? Reader.fromJson(json['readers']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'loan_id': id,
        'instance_id': instanceId,
        'reader_id': readerId,
        'issue_date': issueDate?.toIso8601String(),
        'due_date': dueDate?.toIso8601String(),
        'return_date': returnDate?.toIso8601String(),
      };
}