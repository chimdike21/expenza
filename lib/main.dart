import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/expense.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
    Hive.registerAdapter(ExpenseAdapter());
  
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
      
      debugShowCheckedModeBanner: false,
            home: FutureBuilder(
        future: Hive.openBox<Expense>('expenses'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const HomeScreen();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
    
  }
}


