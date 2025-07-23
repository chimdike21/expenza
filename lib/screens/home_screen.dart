import 'package:expenza/models/expense.dart';
import 'package:expenza/widgets/expense_form.dart';
import 'package:flutter/material.dart';
import 'package:expenza/screens/expense_list.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Expense> expenseBox;

  void initState() {
    super.initState();
    expenseBox = Hive.box<Expense>('expenses');
  }

  void _deleteExpense(MapEntry<dynamic, Expense> entry) {
    final key = entry.key;
    final expense = entry.value;
    expenseBox.delete(key);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Expense ${expense.title} deleted.',
          style: TextStyle(fontFamily: 'Nunito', fontSize: 16),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          title: Text(
            'expenza',
            style: TextStyle(
              color: Colors.lightGreen,
              //fontWeight: FontWeight.bold,
              fontSize: 55,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE8F5E9), Colors.white],
              ),
            ),
          ),
        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment(0, -0.4),
            child: Column(
              children: [
                Text(
                  'Welcome to expenza!',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.green, // money-green text
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Track your expenses, control your future.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87, // light grey text
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Nunito',
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExpenseList(
                        expenses: expenseBox.toMap().entries.toList(),
                        onDelete: _deleteExpense,
                      ), // Replace with real list later
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Track Expenses',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
              const SizedBox(height: 20), //space the buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExpenseForm(
                        onSubmit: (expense) {
                          expenseBox.add(expense);
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Add Expense',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
              const SizedBox(height: 40), //space the buttons
            ],
          ),
        ],
      ),
    ); //return const Placeholder();
  }
}
