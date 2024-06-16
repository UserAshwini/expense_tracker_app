import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/models/expense.dart';

sealed class GetExpensesState extends Equatable {
  const GetExpensesState();

  @override
  List<Object> get props => [];
}

final class GetExpensesInitial extends GetExpensesState {}

final class GetExpensesFailure extends GetExpensesState {}

final class GetExpensesLoading extends GetExpensesState {}

final class GetExpensesSuccess extends GetExpensesState {
  final List<Expense> expenses;

  const GetExpensesSuccess(this.expenses);

  @override
  List<Object> get props => [expenses];
}
