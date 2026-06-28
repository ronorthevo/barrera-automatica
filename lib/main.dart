import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const BarreraApp());
}

class BarreraApp extends StatelessWidget {
  const BarreraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barrera Automática',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomePage(),
    );
  }
}