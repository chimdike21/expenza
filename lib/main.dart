import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    const ExpenzaApp(),
  );
  
}

class ExpenzaApp extends StatelessWidget {
  const ExpenzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenza',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
    
  }
}


