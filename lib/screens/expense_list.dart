import 'package:expenza/widgets/expense_item.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import '../models/expense.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseList({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Expenses')),
      body: expenses.isEmpty
          ? const Center(
              child: Text(
                'No expenses found. Start adding some!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Nunito',
                ),
              ),
            )
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (ctx, index) {
                final exp = expenses[index];
                return ExpenseItem(expense: exp);
              },
            ),
    );
  }
}
