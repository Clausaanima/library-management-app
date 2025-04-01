// Кнопка в виде книги
import 'package:flutter/material.dart';

class BookButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  BookButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Color(0xFFF5F5DC),
          border: Border.all(color: Color.fromARGB(255, 136, 91, 8), width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(label, style: TextStyle(fontSize: 18, fontFamily: 'Roboto', fontStyle: FontStyle.italic)),
      ),
    );
  }
}
