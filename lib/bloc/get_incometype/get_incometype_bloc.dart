import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/models/incometype.dart';
import 'package:expense_tracker_app/repoitories/expense_repo.dart';

part 'get_incometype_event.dart';
part 'get_incometype_state.dart';

class GetIncometypeBloc extends Bloc<GetIncometypeEvent, GetIncometypeState> {
  ExpenseRepository expenseRepository;
  GetIncometypeBloc(this.expenseRepository) : super(GetIncometypeInitial()) {
    on<GetIncometype>((event, emit) async {
      emit(GetIncometypeLoading());
      try {
        List<IncomeType> incometype =
            await expenseRepository.getIncomeTypes(event.uid);
        emit(GetIncometypeSuccess(incometype));
      } catch (e) {
        emit(GetIncometypeFailure());
      }
    });
  }
}
