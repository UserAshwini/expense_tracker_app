import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/models/income.dart';
import 'package:expense_tracker_app/repoitories/expense_repo.dart';

part 'create_income_event.dart';
part 'create_income_state.dart';

class CreateIncomeBloc extends Bloc<CreateIncomeEvent, CreateIncomeState> {
  ExpenseRepository expenseRepository;
  CreateIncomeBloc(this.expenseRepository) : super(CreateIncomeInitial()) {
    on<CreateIncome>((event, emit) async {
      emit(CreateIncomeLoading());
      try {
        await expenseRepository.createIncome(event.income);
        emit(CreateIncomeSuccess());
      } catch (e) {
        emit(CreateIncomeFailure());
      }
    });
  }
}
