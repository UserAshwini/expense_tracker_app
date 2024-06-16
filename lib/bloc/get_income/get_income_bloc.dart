import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/models/income.dart';
import 'package:expense_tracker_app/repoitories/expense_repo.dart';

part 'get_income_event.dart';
part 'get_income_state.dart';

class GetIncomeBloc extends Bloc<GetIncomeEvent, GetIncomeState> {
  ExpenseRepository expenseRepository;
  GetIncomeBloc(this.expenseRepository) : super(GetIncomeInitial()) {
    on<GetIncome>((event, emit) async {
      emit(GetIncomeLoading());
      try {
        List<Income> expenses = await expenseRepository.getIncome();
        emit(GetIncomeSuccess(expenses));
      } catch (e) {
        emit(GetIncomeFailure());
      }
    });
  }
}
