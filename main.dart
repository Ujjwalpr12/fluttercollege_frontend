import 'package:flutter/material.dart';
import '../screens/login_page.dart';
import '../screens/home_page.dart'; // Import the HomeScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Default route
      routes: {
        '/login': (context) => LoginScreen(), // Login screen
        '/home': (context) => HomeScreen(), // Home screen
      },
    );
  }
}