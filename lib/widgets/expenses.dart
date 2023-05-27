import 'package:expenses/widgets/chart/chart.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'expense list/expense_list.dart';
import 'modal_overlay.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> expenses = [
    Expense(
        amount: 898,
        title: "gated",
        category: Category.leisure,
        date: DateTime.now()),
    Expense(
        amount: 788,
        title: "gated",
        category: Category.food,
        date: DateTime.now()),
    Expense(
        amount: 7898,
        title: "gated",
        category: Category.food,
        date: DateTime.now()),
    Expense(
        amount: 7,
        title: "gated",
        category: Category.food,
        date: DateTime.now()),
  ];
  void _showOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => ModalOverlay(_addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    var eIndex = expenses.indexOf(expense);

    setState(() {
      expenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Undo"),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              expenses.insert(eIndex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses"),
        actions: [
          IconButton(
            onPressed: _showOverlay,
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Chart(expenses: expenses),
          ExpenseList(expenses: expenses, onDismiss: _removeExpense),
        ],
      ),
    );
  }
}
