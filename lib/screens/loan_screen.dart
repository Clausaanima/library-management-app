import 'package:biblio/model/loan.dart';
import 'package:biblio/service/library_service.dart';
import 'package:biblio/widgets/book_button.dart';
import 'package:biblio/widgets/book_dialog.dart';
import 'package:biblio/widgets/loan_card.dart';
import 'package:flutter/material.dart';

class LoanScreen extends StatefulWidget {
  @override
  _LoanScreenState createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  final LibraryService _service = LibraryService();
  List<Loan> loans = [];
  List<Loan> filteredLoans = [];
  TextEditingController searchCtrl = TextEditingController();
  String? selectedStatus;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchLoans();
    searchCtrl.addListener(_filterLoans);
  }

  Future<void> _fetchLoans() async {
    final fetchedLoans = await _service.getLoans();
    if (mounted) {
      setState(() {
        loans = fetchedLoans;
        filteredLoans = loans;
      });
    }
  }

  void _filterLoans() {
    final query = searchCtrl.text.toLowerCase();
    setState(() {
      filteredLoans = loans.where((loan) {
        final readerName = loan.reader?.fullName.toLowerCase() ?? '';
        final matchesReader = readerName.contains(query);
        final matchesStatus = selectedStatus == null || loan.bookInstance?.status == selectedStatus;
        final matchesDate = selectedDate == null || 
            (loan.issueDate != null && 
             loan.issueDate!.year == selectedDate!.year && 
             loan.issueDate!.month == selectedDate!.month && 
             loan.issueDate!.day == selectedDate!.day);
        return matchesReader && matchesStatus && matchesDate;
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
      appBar: AppBar(title: Text('Выдача книг', style: TextStyle(fontFamily: 'Roboto'))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showIssueDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF87CEEB),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.png'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: searchCtrl,
                    decoration: InputDecoration(
                      labelText: 'Поиск по ФИО читателя',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    hint: Text('Фильтр по статусу'),
                    value: selectedStatus,
                    items: ['available', 'issued'].map((status) {
                      return DropdownMenuItem<String>(value: status, child: Text(status));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                        _filterLoans();
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                          _filterLoans();
                        });
                      }
                    },
                    child: Text(selectedDate == null ? 'Выбрать дату' : 'Дата: ${selectedDate!.toString().substring(0, 10)}'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: filteredLoans.length,
                itemBuilder: (context, index) {
                  final loan = filteredLoans[index];
                  final bookTitle = loan.bookInstance?.book?.title ?? 'Неизвестная книга';
                  final readerName = loan.reader?.fullName ?? 'Неизвестный читатель';
                  return LoanCard(
                    title: bookTitle,
                    subtitle: 'Читатель: $readerName\nВыдано: ${loan.issueDate?.toString().substring(0, 10) ?? 'N/A'}',
                    onTap: () => _showEditStatusDialog(context, loan),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showIssueDialog(BuildContext context) {
    TextEditingController instanceCtrl = TextEditingController();
    TextEditingController readerCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => BookDialog(
        title: 'Выдать книгу',
        content: [
          TextField(controller: instanceCtrl, decoration: InputDecoration(labelText: 'ID экземпляра'), keyboardType: TextInputType.number),
          TextField(controller: readerCtrl, decoration: InputDecoration(labelText: 'ID читателя'), keyboardType: TextInputType.number),
        ],
        actions: [
          BookButton(
            label: 'Выдать',
            onPressed: () async {
              final loan = Loan(
                id: null,
                instanceId: int.tryParse(instanceCtrl.text) ?? 0,
                readerId: int.tryParse(readerCtrl.text) ?? 0,
                issueDate: DateTime.now(),
                dueDate: DateTime.now().add(Duration(days: 14)),
              );
              await _service.issueBook(loan);
              _fetchLoans();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showEditStatusDialog(BuildContext context, Loan loan) {
    showDialog(
      context: context,
      builder: (_) => BookDialog(
        title: 'Изменить статус',
        content: [
          Text('Книга: ${loan.bookInstance?.book?.title ?? 'N/A'}'),
          Text('Читатель: ${loan.reader?.fullName ?? 'N/A'}'),
          Text('Текущий статус: ${loan.bookInstance?.status ?? 'N/A'}'),
        ],
        actions: [
          if (loan.bookInstance?.status == 'issued')
            BookButton(
              label: 'Вернуть',
              onPressed: () async {
                await _service.returnBook(loan.id ?? 0, loan.instanceId ?? 0);
                _fetchLoans();
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}