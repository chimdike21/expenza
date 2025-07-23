import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
part 'expense.g.dart';

const uuid = Uuid();

@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    
  }) : id = uuid.v4();
}
