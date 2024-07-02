import 'package:bloc/bloc.dart';
import 'package:expense_tracker_app/bloc/create_expense/create_expense_event.dart';
import 'package:expense_tracker_app/bloc/create_expense/create_expense_state.dart';
import 'package:expense_tracker_app/repoitories/expense_repo.dart';

class CreateExpenseBloc extends Bloc<CreateExpenseEvent, CreateExpenseState> {
  ExpenseRepository expenseRepository;

  CreateExpenseBloc(this.expenseRepository) : super(CreateExpenseInitial()) {
    on<CreateExpense>((event, emit) async {
      emit(CreateExpenseLoading());
      try {
        await expenseRepository.createEmptyExpenses(event.uid, event.expense);
        emit(CreateExpenseSuccess());
      } catch (e) {
        emit(CreateExpenseFailure());
      }
    });
  }
}
