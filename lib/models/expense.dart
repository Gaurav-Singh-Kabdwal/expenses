import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();

final formatter = DateFormat.yMd();

enum Category { food, travel, leisure, work }

const icons = {
  Category.food: Icons.food_bank,
  Category.leisure: Icons.movie,
  Category.travel: Icons.flight,
  Category.work: Icons.work
};

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.category,
      required this.date})
      : id = uuid.v4();

  final String title;
  final String id;
  final double amount;
  final DateTime date;
  final Category category;

  String get getDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.expenses, required this.category});

  final List<Expense> expenses;
  final Category category;

  ExpenseBucket.category(List<Expense> expenseList, this.category)
      : expenses = expenseList
            .where((expense) => expense.category == category)
            .toList();

  double get getTotal {
    var sum = 0.0;
    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
