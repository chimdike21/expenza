import 'package:expenza/widgets/expense_item.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import '../models/expense.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(Expense) onDelete;

  const ExpenseList({
    super.key,
    required this.expenses,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final expenseCount = expenses.length;
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
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  color: Colors.green[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Expenses: ₦${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.green,
                          fontFamily: 'Nunito',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You have made $expenseCount expenses',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return Dismissible(
                        key: ValueKey(expense.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          onDelete(expense);
                        },
                        child: ExpenseItem(
                          expense: expense,
                          onDelete: onDelete,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
