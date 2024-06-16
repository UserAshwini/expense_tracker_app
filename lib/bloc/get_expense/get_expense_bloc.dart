import 'package:expense_tracker_app/bloc/get_expense/get_expense_event.dart';
import 'package:expense_tracker_app/bloc/get_expense/get_expense_state.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/repoitories/expense_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetExpensesBloc extends Bloc<GetExpensesEvent, GetExpensesState> {
  ExpenseRepository expenseRepository;

  GetExpensesBloc(this.expenseRepository) : super(GetExpensesInitial()) {
    on<GetExpenses>((event, emit) async {
      emit(GetExpensesLoading());
      try {
        List<Expense> expenses = await expenseRepository.getExpenses();
        emit(GetExpensesSuccess(expenses));
      } catch (e) {
        emit(GetExpensesFailure());
      }
    });
  }
}
