import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'dart:async';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<String> quotes = [
    "«Книга — это мечта, которую ты держишь в руках.» — Нил Гейман",
    "«Чтение — это путешествие, которое не требует багажа.» — неизвестный",
    "«Книги — это зеркала души.» — Вирджиния Вулф",
  ];
  int _quoteIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() => _quoteIndex = (_quoteIndex + 1) % quotes.length);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black54, // Полупрозрачный фон
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Добро пожаловать в библиотеку!',
                  style: TextStyle(fontSize: 32, color: Colors.white, fontFamily: 'Roboto'),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  quotes[_quoteIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, color: Colors.white70, fontFamily: 'Roboto'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen())),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5DC),
                      border: Border.all(color: Color.fromARGB(255, 147, 83, 5), width: 2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text('Войти', style: TextStyle(fontSize: 22, fontFamily: 'Roboto')),
                  ),
                ),
 SizedBox(height: 20),
                Text(
                  'Сегодня: ${DateTime.now().toString().substring(0, 10)}',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Roboto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}