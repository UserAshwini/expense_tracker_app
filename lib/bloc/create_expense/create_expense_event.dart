import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/models/expense.dart';

sealed class CreateExpenseEvent extends Equatable {
  const CreateExpenseEvent();

  @override
  List<Object> get props => [];
}

class CreateExpense extends CreateExpenseEvent {
  final Expense expense;

  const CreateExpense(this.expense);

  @override
  List<Object> get props => [expense];
}
