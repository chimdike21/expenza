import 'package:expenza/widgets/expense_item.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import '../models/expense.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expenza/widgets/expense_form.dart';

class ExpenseList extends StatefulWidget {
  final List<MapEntry<dynamic, Expense>> expenses;
  final void Function(MapEntry<dynamic, Expense>) onDelete;

  const ExpenseList({
    super.key,
    required this.expenses,
    required this.onDelete,
  });

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Expenses')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Expense>('expenses').listenable(),
        builder: (context, Box<Expense> box, _) {
          final entries = box.toMap().entries.toList();
          final totalAmount = entries.fold(
            0.0,
            (sum, e) => sum + e.value.amount,
          );
          final expenseCount = entries.length;

          if (entries.isEmpty) {
            return const Center(
              child: Text(
                'No expenses found. Start adding some!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Nunito',
                ),
              ),
            );
          }

          return Column(
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
                        color: Colors.black87,
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final expense = entry.value;
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
                        widget.onDelete(entry);
                      },
                      child: ExpenseItem(
                        expense: expense,
                        onDelete: (_) => widget.onDelete(entry),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExpenseForm(expense: expense, onSubmit: (_) {  },),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
