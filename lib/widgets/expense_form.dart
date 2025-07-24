import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';


class ExpenseForm extends StatefulWidget {
  final void Function(Expense expense) onSubmit;
  final Expense? expense;

  const ExpenseForm({super.key, required this.onSubmit, this.expense});

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  String? selectedCategory;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    final exp = widget.expense;
    if (exp != null) {
      titleController.text = exp.title;
      amountController.text = exp.amount.toString();
      selectedCategory = exp.category;
      selectedDate = exp.date;
    }
  }

  void _presentDatepicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text(widget.expense != null ? 'Update Expense' : 'Add New Expense')),
      body: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.expense != null ? 'Update Expense' : 'Add New Expense',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Food', child: Text('Food')),
                DropdownMenuItem(value: 'Transport', child: Text('Transport')),
                DropdownMenuItem(value: 'Shopping', child: Text('Shopping')),
                DropdownMenuItem(value: 'Bills', child: Text('Bills')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              value: selectedCategory,
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'No Date Chosen'
                        : 'Picked Date: ${DateFormat.yMMMd().format(selectedDate!)}',
                  ),
                ),
                TextButton(
                  onPressed: _presentDatepicker,
                  child: const Text('Choose Date'),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  //logic
                  final enteredTitle = titleController.text.trim();
                  final enteredAmount = double.tryParse(
                    amountController.text.trim().replaceAll(',', ''),
                  );

                  if (enteredTitle.isEmpty ||
                      enteredAmount == null ||
                      enteredAmount <= 0 ||
                      selectedCategory == null ||
                      selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all fields correctly!'),
                      ),
                    );
                    return;
                  }

                  //temporary output
                  print('Title: $enteredTitle');
                  print('Amount: $enteredAmount');
                  print('Category: $selectedCategory');
                  print('Date: ${DateFormat.yMMMd().format(selectedDate!)}');

                  if (widget.expense != null) {
                    // Update existing expense
                    widget.expense!
                      ..title = enteredTitle
                      ..amount = enteredAmount
                      ..category = selectedCategory!
                      ..date = selectedDate!;
                    widget.expense!.save();
                  } else {
                    //add new expense
                    widget.onSubmit(
                      Expense(
                        title: enteredTitle,
                        amount: enteredAmount,
                        category: selectedCategory!,
                        date: selectedDate!,
                      ),
                    );
                  }

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 60,
                            ),
                            const SizedBox(height: 12),
                            Text(
                            widget.expense != null ? 'Expense Updated!' : 'Expense Added!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );

                  // Delay and then pop the form after showing dialog
                  Future.delayed(const Duration(seconds: 1), () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop(); // close dialog
                    }
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop(); // close form
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // money-green button
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child:  Text(
                  widget.expense != null ? 'Update Expense' : 'Add Expense',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
