import 'package:flutter/material.dart';
import 'package:expenses/models/expense.dart';

import 'expense_item.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {required this.expenses, required this.onDismiss, super.key});
  final List<Expense> expenses;
  final void Function(Expense e) onDismiss;
  @override
  Widget build(context) {
    Widget expenseItem = const Center(
      child: Text("No expenses to show. Add expenses."),
    );

    if (expenses.isNotEmpty) {
      expenseItem = ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) => Dismissible(
          background: Container(
            color: Colors.red,
            margin: Theme.of(context).cardTheme.margin,
          ),
          key: ValueKey(expenses[index]),
          onDismissed: (direction) {
            onDismiss(expenses[index]);
          },
          child: ExpenseItem(expenses[index]),
        ),
      );
    }

    return Expanded(
      child: expenseItem,
    );
  }
}
