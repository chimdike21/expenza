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
  String selectedRange = '1M';

  String _getRangeLabel() {
    final now = DateTime.now();

    switch (selectedRange) {
      case '1D':
        return 'the last day';
      case '1W':
        return 'the last week';
      case '1M':
        return '${now.month}-${now.year}';
      case '3M':
        return 'the last 3 months';
      case '1Y':
        return 'the year ${now.year}';
      default:
       return '${now.month}-${now.year}';
    }
  }

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
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₦${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Nunito',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Spent in ${_getRangeLabel()}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    //pie placeholder
                    Center(
                      child: Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'Pie Chart',
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ),
                        
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: ['1D', '1W', '1M', '3M', '1Y'].map((range) {
                        return ChoiceChip(
                          label: Text(range,
                          style: TextStyle(
                            color: selectedRange == range ? Colors.white : Colors.black,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                          )),
                          selectedColor: Colors.green,
                          backgroundColor: Colors.grey[200],
                          selected: selectedRange == range,
                          onSelected: (_){
                            setState(() {
                              selectedRange = range;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
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
                              builder: (_) => ExpenseForm(
                                expense: expense,
                                onSubmit: (_) {},
                              ),
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
