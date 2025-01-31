import 'package:expense_tracker_flutter/widgets/chart/chart.dart';
import 'package:expense_tracker_flutter/widgets/expenses%20list/expenses_list.dart';
import 'package:expense_tracker_flutter/models/expense.dart';
import 'package:expense_tracker_flutter/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerdExpense = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.99,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'Newspaper',
      amount: 5.99,
      date: DateTime.now(),
      category: Category.leisure,
    )
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(expense) {
    setState(() {
      _registerdExpense.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registerdExpense.indexOf(expense);
    setState(() {
      _registerdExpense.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 4),
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registerdExpense.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registerdExpense.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _registerdExpense, removeExpense: _removeExpense);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(children: [
              Chart(expenses: _registerdExpense),
              Expanded(
                child: mainContent,
              )
            ])
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registerdExpense)),
                Expanded(
                  child: mainContent,
                )
              ],
            ),
    );
  }
}
