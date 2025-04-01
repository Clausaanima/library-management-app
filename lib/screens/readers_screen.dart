import 'package:biblio/model/reader.dart';
import 'package:biblio/service/library_service.dart';
import 'package:biblio/widgets/book_button.dart';
import 'package:biblio/widgets/book_dialog.dart';
import 'package:biblio/widgets/reader_card.dart';
import 'package:flutter/material.dart';

class ReadersScreen extends StatefulWidget {
  @override
  _ReadersScreenState createState() => _ReadersScreenState();
}

class _ReadersScreenState extends State<ReadersScreen> {
  final LibraryService _service = LibraryService();
  List<Reader> readers = [];
  List<Reader> filteredReaders = [];
  TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchReaders();
    searchCtrl.addListener(_filterReaders);
  }

  Future<void> _fetchReaders() async {
    final fetchedReaders = await _service.getReaders();
    if (mounted) {
      setState(() {
        readers = fetchedReaders;
        filteredReaders = readers;
      });
    }
  }

  void _filterReaders() {
    final query = searchCtrl.text.toLowerCase();
    setState(() {
      filteredReaders = readers.where((reader) {
        return reader.fullName.toLowerCase().contains(query);
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
      backgroundColor: Color(0xFFF5F5DC),
      appBar: AppBar(
        title: Text('Читатели', style: TextStyle(fontFamily: 'Roboto')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF87CEEB),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                labelText: 'Поиск по ФИО',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: filteredReaders.length + 2, // +2: start image, end image
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    child: Image.asset('assets/images/reader1.jpg', fit: BoxFit.cover),
                  );
                } else if (index == filteredReaders.length + 1) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    child: Image.asset('assets/images/reader.png', fit: BoxFit.cover),
                  );
                } else {
                  final reader = filteredReaders[index - 1];
                  return ReaderCard(
                    title: reader.fullName,
                    subtitle: reader.email ?? 'Нет email',
                    onTap: () => _showEditDialog(context, reader),
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
    TextEditingController nameCtrl = TextEditingController();
    TextEditingController phoneCtrl = TextEditingController();
    TextEditingController emailCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => BookDialog(
        title: 'Новый читатель',
        content: [
          TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'ФИО')),
          TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: 'Телефон')),
          TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email')),
        ],
        actions: [
          BookButton(
            label: 'Добавить',
            onPressed: () async {
              final reader = Reader(
                id: null, // ID генерируется Supabase
                fullName: nameCtrl.text,
                phone: phoneCtrl.text.isEmpty ? null : phoneCtrl.text,
                email: emailCtrl.text.isEmpty ? null : emailCtrl.text,
              );
              await _service.addReader(reader);
              _fetchReaders();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Reader reader) {
    TextEditingController nameCtrl = TextEditingController(text: reader.fullName);
    TextEditingController phoneCtrl = TextEditingController(text: reader.phone);
    TextEditingController emailCtrl = TextEditingController(text: reader.email);
    showDialog(
      context: context,
      builder: (_) => BookDialog(
        title: 'Редактировать читателя',
        content: [
          TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'ФИО')),
          TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: 'Телефон')),
          TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email')),
        ],
        actions: [
          BookButton(
            label: 'Сохранить',
            onPressed: () async {
              final updatedReader = Reader(
                id: reader.id ?? 0,
                fullName: nameCtrl.text,
                phone: phoneCtrl.text.isEmpty ? null : phoneCtrl.text,
                email: emailCtrl.text.isEmpty ? null : emailCtrl.text,
              );
              await _service.updateReader(updatedReader);
              _fetchReaders();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}