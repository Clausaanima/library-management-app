import 'package:flutter/material.dart';

// Карточка книги
class ReaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final ImageProvider? image; 

  ReaderCard({required this.title, required this.subtitle, this.onTap, this.image,});
  


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color.fromARGB(76, 135, 207, 235),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
        ),
        child: Column(
          children: [
            Expanded(
              child: image != null
                  ? Image(image: image!, fit: BoxFit.cover)
                  : Image.asset('assets/images/reader2.jpg', fit: BoxFit.cover),
            ), // Место для обложки
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 26),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 22),
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
