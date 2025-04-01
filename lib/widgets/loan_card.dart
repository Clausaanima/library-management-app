import 'package:flutter/material.dart';

// Карточка книги
class LoanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final ImageProvider? image; 

  LoanCard({required this.title, required this.subtitle, this.onTap, this.image,});
  


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color.fromARGB(118, 133, 72, 11),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
        ),
        child: Column(
          children: [
            Expanded(
              child: image != null
                  ? Image(image: image!, fit: BoxFit.cover)
                  : Image.asset('assets/images/bg2.png', fit: BoxFit.cover),
            ), // Место для обложки
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 26, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 22, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
