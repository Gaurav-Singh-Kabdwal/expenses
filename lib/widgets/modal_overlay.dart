import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

final formatter = DateFormat.yMd();

class ModalOverlay extends StatefulWidget {
  const ModalOverlay(this.addExpense(Expense e), {super.key});
  final void Function(Expense) addExpense;
  @override
  State<ModalOverlay> createState() => _ModalOverlayState();
}

class _ModalOverlayState extends State<ModalOverlay> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  var _selectedCategory = Category.leisure;

  void _showCalendar() {
    final now = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: now,
            firstDate: DateTime(now.year - 1, now.month, now.day),
            lastDate: now)
        .then((value) {
      setState(() {
        _selectedDate = value;
      });
      return value;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var kColor = Theme.of(context).colorScheme.surfaceTint;

    void submitExpenseData() {
      final amount = double.tryParse(_amountController.text);
      final isAmountValid = amount == null || amount < 0;

      if (_titleController.text.trim().isEmpty ||
          isAmountValid ||
          _selectedDate == null) {
        if (Platform.isIOS) {
          showCupertinoDialog(
              context: context,
              builder: (ctx) => CupertinoAlertDialog(
                    title: Text(
                      "Invalid Input",
                      style: TextStyle(
                        color: kColor,
                      ),
                    ),
                    content: Text(
                      "Please make sure that valid title, amount, date and category was entered.",
                      style: TextStyle(
                        color: kColor,
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          child: Text(
                            "Okay",
                            style: TextStyle(
                              color: kColor,
                            ),
                          )),
                    ],
                  ));
        } else {
          showDialog(
            useSafeArea: true,
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                "Invalid Input",
                style: TextStyle(
                  color: kColor,
                ),
              ),
              content: Text(
                "Please make sure that valid title, amount, date and category was entered.",
                style: TextStyle(
                  color: kColor,
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text(
                      "Okay",
                      style: TextStyle(
                        color: kColor,
                      ),
                    )),
              ],
            ),
          );
        }
        return;
      }
      widget.addExpense(Expense(
          title: _titleController.text,
          amount: amount,
          category: _selectedCategory,
          date: _selectedDate!));

      Navigator.pop(context);
    }

    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return LayoutBuilder(builder: (ctx, constraints) {
      var width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardHeight + 16),
            child: Column(
              children: [
                if (width > 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surfaceTint,
                          ),
                          controller: _titleController,
                          decoration: const InputDecoration(
                            label: Text(
                              "Title",
                            ),
                          ),
                          maxLength: 50,
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surfaceTint,
                          ),
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text("Amount"),
                            prefixText: "₹ ",
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surfaceTint,
                    ),
                    controller: _titleController,
                    decoration: const InputDecoration(
                      label: Text(
                        "Title",
                      ),
                    ),
                    maxLength: 50,
                  ),
                if (width > 600)
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton(
                            value: _selectedCategory,
                            dropdownColor: Theme.of(context).canvasColor,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category.name[0].toUpperCase() +
                                          category.name
                                              .substring(1)
                                              .toLowerCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Theme.of(context).cardTheme.color,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedCategory = value;
                              });
                            }),
                      ),
                      const Spacer(),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? "No date selected"
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _showCalendar,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surfaceTint,
                          ),
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text("Amount"),
                            prefixText: "₹ ",
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _selectedDate == null
                                ? "No date selected"
                                : formatter.format(_selectedDate!),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          IconButton(
                            onPressed: _showCalendar,
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (width > 600)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: submitExpenseData,
                        child: const Text("Save"),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton(
                            value: _selectedCategory,
                            dropdownColor: Theme.of(context).canvasColor,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category.name[0].toUpperCase() +
                                          category.name
                                              .substring(1)
                                              .toLowerCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Theme.of(context).cardTheme.color,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedCategory = value;
                              });
                            }),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: submitExpenseData,
                        child: const Text("Save"),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
