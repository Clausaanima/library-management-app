import 'package:biblio/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ouwdiuetgsilmsqpzjaj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91d2RpdWV0Z3NpbG1zcXB6amFqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMzNDExMzksImV4cCI6MjA1ODkxNzEzOX0.eDGm5OWK3UE24tWmmIKDFPqREkUsrOiwrmmsRyYD3uw',
  );
  runApp(LibraryApp());
}

class LibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Библиотечный фонд',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Roboto',
      ),
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}