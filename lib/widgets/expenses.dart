import 'package:expenses_manaer_v2/main.dart';
import 'package:expenses_manaer_v2/widgets/chart/chart.dart';
import 'package:expenses_manaer_v2/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expenses_manaer_v2/Models/expense.dart';
import 'package:expenses_manaer_v2/widgets/expenses_lists/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 1999,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 200,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final clr = isDarkMode
        ? Theme.of(context).primaryColor
        : Theme.of(context).dialogBackgroundColor;

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted!'),
        action: SnackBarAction(
          textColor: clr,
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final clr = isDarkMode
        ? Theme.of(context).primaryColorLight
        : Theme.of(context).dialogBackgroundColor;

    Widget mainContent = const Center(
      child: Text('No expenses found, try adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
            color: clr,
            onPressed: _openAddExpensesOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(
                  expenses: _registeredExpenses,
                ),
                Expanded(
                  child: mainContent,
                )
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(
                  child: mainContent,
                )
              ],
            ),
    );
  }
}
