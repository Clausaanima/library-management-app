import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/book.dart';
import '../model/book_instance.dart';
import '../model/loan.dart';
import '../model/reader.dart';

class LibraryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Работа с книгами
  Future<List<Book>> getBooks() async {
    try {
      final response = await _supabase.from('books').select();
      return (response as List<dynamic>).map((json) => Book.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching books: $e');
      return [];
    }
  }

  Future<void> addBook(Book book) async {
    try {
      await _supabase.from('books').insert(book.toJson());
    } catch (e) {
      print('Error adding book: $e');
      rethrow;
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      await _supabase.from('books').update(book.toJson()).eq('book_id', book.id ?? 0);
    } catch (e) {
      print('Error updating book: $e');
      rethrow;
    }
  }

  Future<void> deleteBook(int bookId) async {
    try {
      await _supabase.from('books').delete().eq('book_id', bookId);
    } catch (e) {
      print('Error deleting book: $e');
      rethrow;
    }
  }

  // Работа с читателями
  Future<List<Reader>> getReaders() async {
    try {
      final response = await _supabase.from('readers').select();
      return (response as List<dynamic>).map((json) => Reader.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching readers: $e');
      return [];
    }
  }

  Future<void> addReader(Reader reader) async {
    try {
      await _supabase.from('readers').insert(reader.toJson());
    } catch (e) {
      print('Error adding reader: $e');
      rethrow;
    }
  }

  Future<void> updateReader(Reader reader) async {
    try {
      await _supabase.from('readers').update(reader.toJson()).eq('reader_id', reader.id ?? 0);
    } catch (e) {
      print('Error updating reader: $e');
      rethrow;
    }
  }

  // Работа с экземплярами книг
  Future<List<BookInstance>> getBookInstances(int bookId) async {
    try {
      final response = await _supabase.from('book_instances').select().eq('book_id', bookId);
      return (response as List<dynamic>).map((json) => BookInstance.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching book instances: $e');
      return [];
    }
  }

  Future<void> addBookInstance(BookInstance instance) async {
    try {
      await _supabase.from('book_instances').insert(instance.toJson());
    } catch (e) {
      print('Error adding book instance: $e');
      rethrow;
    }
  }

  // Работа с выдачей
  Future<List<Loan>> getLoans() async {
    try {
      final response = await _supabase
          .from('loans')
          .select('*, book_instances(book_id, instance_code, status, books(book_id, title, author)), readers(full_name, phone, email)');
      return (response as List<dynamic>).map((json) => Loan.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching loans: $e');
      return [];
    }
  }

  Future<void> issueBook(Loan loan) async {
    try {
      await _supabase.from('loans').insert(loan.toJson());
      await _supabase.from('book_instances').update({'status': 'issued'}).eq('instance_id', loan.instanceId ?? 0);
      final bookId = await _getBookId(loan.instanceId ?? 0);
      final availableCopies = await _getAvailableCopies(bookId);
      await _supabase.from('books').update({'available_copies': availableCopies}).eq('book_id', bookId);
    } catch (e) {
      print('Error issuing book: $e');
      rethrow;
    }
  }

  Future<void> returnBook(int loanId, int instanceId) async {
    try {
      await _supabase.from('book_instances').update({'status': 'available'}).eq('instance_id', instanceId);
      await _supabase.from('loans').update({'return_date': DateTime.now().toIso8601String()}).eq('loan_id', loanId);
      final bookId = await _getBookId(instanceId);
      final availableCopies = await _getAvailableCopies(bookId);
      await _supabase.from('books').update({'available_copies': availableCopies}).eq('book_id', bookId);
    } catch (e) {
      print('Error returning book: $e');
      rethrow;
    }
  }

  Future<int> _getBookId(int instanceId) async {
    try {
      final response = await _supabase.from('book_instances').select('book_id').eq('instance_id', instanceId).single();
      return response['book_id'] as int? ?? 0;
    } catch (e) {
      print('Error fetching book ID: $e');
      return 0;
    }
  }

  Future<int> _getAvailableCopies(int bookId) async {
    try {
      final response = await _supabase.from('book_instances').select().eq('book_id', bookId).eq('status', 'available');
      return (response as List<dynamic>).length;
    } catch (e) {
      print('Error fetching available copies: $e');
      return 0;
    }
  }
}