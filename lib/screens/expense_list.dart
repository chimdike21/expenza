import 'package:expenza/widgets/expense_item.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import '../models/expense.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expenza/widgets/expense_form.dart';
import 'package:fl_chart/fl_chart.dart';

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

    List<Widget> _buildCategoryGroups(List<MapEntry<dynamic, Expense>> entries) {
    final Map<String, List<Expense>> grouped = {};

    for (var entry in entries) {
      final exp = entry.value;
      if (!grouped.containsKey(exp.category)) {
        grouped[exp.category] = [];
      }
      grouped[exp.category]!.add(exp);
    }

    return grouped.entries.map((group) {
      final total = group.value.fold(0.0, (sum, item) => sum + item.amount);
      final icon = Icons.category; // You can later customize icons per category

      return ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(
          group.key,
          style: const TextStyle(fontFamily: 'Nunito'),
        ),
        subtitle: Text('${group.value.length} transactions'),
        trailing: Text(
          '₦${total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito',
          ),
        ),
      );
    }).toList();
  }

  List<PieChartSectionData> _buildPieChartSections(List<MapEntry<dynamic, Expense>> entries) {
    final Map<String, double> categoryTotals = {};

    for (var entry in entries) {
      final exp = entry.value;
      categoryTotals[exp.category] = (categoryTotals[exp.category] ?? 0) + exp.amount;
    }

    final colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.brown,
      Colors.teal,
    ];

    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);
    int i = 0;

    return categoryTotals.entries.map((e) {
      final percent = (e.value / total) * 100;
      return PieChartSectionData(
        color: colors[i++ % colors.length],
        value: e.value,
        title: '${percent.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito',
        ),
      );
    }).toList();
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
                    
                      SizedBox(
                        height:160,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            sections: _buildPieChartSections(entries)
                          )
                        )
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        'Expenses by Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ),

                    ..._buildCategoryGroups(entries),

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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: BorderSide(
                            color: selectedRange == range ? Colors.green : Colors.transparent,
                            width: 1.5,
                          ),
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
