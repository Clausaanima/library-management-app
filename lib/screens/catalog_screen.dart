import 'package:biblio/model/book.dart';
import 'package:biblio/service/library_service.dart';
import 'package:biblio/widgets/book_button.dart';
import 'package:biblio/widgets/book_card.dart';
import 'package:biblio/widgets/book_dialog.dart';
import 'package:flutter/material.dart';

class CatalogScreen extends StatefulWidget {
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final LibraryService _service = LibraryService();
  List<Book> books = [];
  List<Book> filteredBooks = [];
  TextEditingController searchCtrl = TextEditingController();
  String? selectedYear;
  String? selectedAuthor;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
    searchCtrl.addListener(_filterBooks);
  }

  Future<void> _fetchBooks() async {
    final fetchedBooks = await _service.getBooks();
    if (mounted) {
      setState(() {
        books = fetchedBooks;
        filteredBooks = books;
      });
    }
  }

  void _filterBooks() {
    final query = searchCtrl.text.toLowerCase();
    setState(() {
      filteredBooks = books.where((book) {
        final matchesTitle = book.title.toLowerCase().contains(query);
        final matchesYear = selectedYear == null || book.publicationYear?.toString() == selectedYear;
        final matchesAuthor = selectedAuthor == null || book.author == selectedAuthor;
        return matchesTitle && matchesYear && matchesAuthor;
      }).toList();
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 234, 220),
      appBar: AppBar(title: Text('Каталог книг', style: TextStyle(fontFamily: 'Roboto'))),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: searchCtrl,
                  decoration: InputDecoration(
                    labelText: 'Поиск по названию',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  hint: Text('Фильтр по году'),
                  value: selectedYear,
                  items: books.map((book) => book.publicationYear?.toString()).toSet().map((year) {
                    return DropdownMenuItem<String>(value: year, child: Text(year ?? 'Без года'));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value;
                      _filterBooks();
                    });
                  },
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  hint: Text('Фильтр по автору'),
                  value: selectedAuthor,
                  items: books.map((book) => book.author).toSet().map((author) {
                    return DropdownMenuItem<String>(value: author, child: Text(author));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAuthor = value;
                      _filterBooks();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: filteredBooks.length + 3, // +3: start image, books, add button, end image
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    child: Image.asset('assets/images/book.png', fit: BoxFit.cover),
                  );
                } else if (index == filteredBooks.length + 1) {
                  return BookCard(
                    title: 'Добавить книгу',
                    subtitle: '',
                    onTap: () => _showAddDialog(context),
                  );
                } else if (index == filteredBooks.length + 2) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    child: Image.asset('assets/images/person.png', fit: BoxFit.cover),
                  );
                } else {
                  final book = filteredBooks[index - 1];
                  return BookCard(
                    title: book.title,
                    subtitle: book.author,
                    onTap: () => _showEditDeleteDialog(context, book),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    TextEditingController titleCtrl = TextEditingController();
    TextEditingController authorCtrl = TextEditingController();
    TextEditingController isbnCtrl = TextEditingController();
    TextEditingController yearCtrl = TextEditingController();
    TextEditingController totalCopiesCtrl = TextEditingController();
    TextEditingController availableCopiesCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => BookDialog(
        title: 'Новая книга',
        content: [
          TextField(controller: titleCtrl, decoration: InputDecoration(labelText: 'Название')),
          TextField(controller: authorCtrl, decoration: InputDecoration(labelText: 'Автор')),
          TextField(controller: isbnCtrl, decoration: InputDecoration(labelText: 'ISBN')),
          TextField(controller: yearCtrl, decoration: InputDecoration(labelText: 'Год публикации'), keyboardType: TextInputType.number),
          TextField(controller: totalCopiesCtrl, decoration: InputDecoration(labelText: 'Общее количество копий'), keyboardType: TextInputType.number),
          TextField(controller: availableCopiesCtrl, decoration: InputDecoration(labelText: 'Доступные копии'), keyboardType: TextInputType.number),
        ],
        actions: [
          BookButton(
            label: 'Добавить',
            onPressed: () async {
              final book = Book(
                id: null,
                title: titleCtrl.text,
                author: authorCtrl.text,
                isbn: isbnCtrl.text.isEmpty ? null : isbnCtrl.text,
                publicationYear: yearCtrl.text.isEmpty ? null : int.tryParse(yearCtrl.text),
                totalCopies: int.tryParse(totalCopiesCtrl.text) ?? 1,
                availableCopies: int.tryParse(availableCopiesCtrl.text) ?? 1,
              );
              await _service.addBook(book);
              _fetchBooks();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showEditDeleteDialog(BuildContext context, Book book) {
    TextEditingController titleCtrl = TextEditingController(text: book.title);
    TextEditingController authorCtrl = TextEditingController(text: book.author);
    TextEditingController isbnCtrl = TextEditingController(text: book.isbn);
    TextEditingController yearCtrl = TextEditingController(text: book.publicationYear?.toString());
    TextEditingController totalCopiesCtrl = TextEditingController(text: book.totalCopies?.toString());
    TextEditingController availableCopiesCtrl = TextEditingController(text: book.availableCopies?.toString());
    showDialog(
      context: context,
      builder: (_) => BookDialog(
        title: 'Редактировать книгу',
        content: [
          TextField(controller: titleCtrl, decoration: InputDecoration(labelText: 'Название')),
          TextField(controller: authorCtrl, decoration: InputDecoration(labelText: 'Автор')),
          TextField(controller: isbnCtrl, decoration: InputDecoration(labelText: 'ISBN')),
          TextField(controller: yearCtrl, decoration: InputDecoration(labelText: 'Год публикации'), keyboardType: TextInputType.number),
          TextField(controller: totalCopiesCtrl, decoration: InputDecoration(labelText: 'Общее количество копий'), keyboardType: TextInputType.number),
          TextField(controller: availableCopiesCtrl, decoration: InputDecoration(labelText: 'Доступные копии'), keyboardType: TextInputType.number),
        ],
        actions: [
          BookButton(
            label: 'Сохранить',
            onPressed: () async {
              final updatedBook = Book(
                id: book.id ?? 0,
                title: titleCtrl.text,
                author: authorCtrl.text,
                isbn: isbnCtrl.text.isEmpty ? null : isbnCtrl.text,
                publicationYear: yearCtrl.text.isEmpty ? null : int.tryParse(yearCtrl.text),
                totalCopies: int.tryParse(totalCopiesCtrl.text) ?? 0,
                availableCopies: int.tryParse(availableCopiesCtrl.text) ?? 0,
              );
              await _service.updateBook(updatedBook);
              _fetchBooks();
              Navigator.pop(context);
            },
          ),
          BookButton(
            label: 'Удалить',
            onPressed: () async {
              await _service.deleteBook(book.id ?? 0);
              _fetchBooks();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}