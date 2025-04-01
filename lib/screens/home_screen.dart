import 'package:biblio/screens/catalog_screen.dart';
import 'package:biblio/screens/loan_screen.dart';
import 'package:biblio/screens/readers_screen.dart';
import 'package:biblio/service/library_service.dart';
import 'package:biblio/widgets/book_button.dart';
import 'package:biblio/widgets/book_page_tile.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LibraryService _service = LibraryService();
  int totalBooks = 0;
  int issuedBooks = 0;
  int overdueBooks = 0;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    final books = await _service.getBooks();
    final loans = await _service.getLoans();
    if (mounted) {
      setState(() {
        totalBooks = books.length;
        issuedBooks = loans.where((loan) => loan.returnDate == null).length;
        overdueBooks = loans.where((loan) => loan.returnDate == null && (loan.dueDate?.isBefore(DateTime.now()) ?? false)).length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
      appBar: AppBar(title: Text('Домашняя страница', style: TextStyle(fontFamily: 'Roboto'))),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.contain,
            opacity: 0.5, // Низкая прозрачность для фона
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 156),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: DateTime.now(),
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {CalendarFormat.month: 'Месяц'},
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                    todayDecoration: BoxDecoration(color: Color(0xFF87CEEB), shape: BoxShape.circle),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: BookPageTile(text: 'Всего книг: $totalBooks', icon: Icons.book, onTap: null)),
                  Expanded(child: BookPageTile(text: 'Выдано: $issuedBooks', icon: Icons.assignment, onTap: null)),
                  Expanded(child: BookPageTile(text: 'Просрочено: $overdueBooks', icon: Icons.warning, onTap: null)),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BookButton(label: 'Каталог', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CatalogScreen()))),
                    BookButton(label: 'Выдача', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoanScreen()))),
                    BookButton(label: 'Читатели', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReadersScreen()))),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}