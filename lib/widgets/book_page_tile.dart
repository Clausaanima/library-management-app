// Страница книги (для читателей или выдачи)
import 'package:flutter/material.dart';

class BookPageTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onTap;

  BookPageTile({required this.text, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border.all(color: Color(0xFF87CEEB)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF87CEEB)),
            SizedBox(width: 10),
            Expanded(child: Text(text, style: TextStyle(fontFamily: 'Roboto'))),
          ],
        ),
      ),
    );
  }
}
