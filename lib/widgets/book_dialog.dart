// Диалоговое окно в виде книги
import 'package:flutter/material.dart';

class BookDialog extends StatelessWidget {
  final String title;
  final List<Widget> content;
  final List<Widget> actions;

  BookDialog({required this.title, required this.content, required this.actions});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFFF5F5DC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: Color(0xFF87CEEB))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: TextStyle(fontSize: 20, fontFamily: 'Roboto')),
            SizedBox(height: 20),
            ...content,
          ],
        ),
      ),
      actions: actions,
    );
  }
}