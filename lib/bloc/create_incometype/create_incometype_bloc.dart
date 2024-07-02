import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/models/incometype.dart';
import 'package:expense_tracker_app/repoitories/expense_repo.dart';

part 'create_incometype_event.dart';
part 'create_incometype_state.dart';

class CreateIncometypeBloc
    extends Bloc<CreateIncometypeEvent, CreateIncometypeState> {
  ExpenseRepository expenseRepository;
  CreateIncometypeBloc(this.expenseRepository)
      : super(CreateIncometypeInitial()) {
    on<CreateIncometype>((event, emit) async {
      emit(CreateIncometypeLoading());
      try {
        await expenseRepository.createEmptyIncomeTypes(
            event.uid, event.incometype);
        emit(CreateIncometypeSuccess());
      } catch (e) {
        emit(CreateIncometypeFailure());
      }
    });
  }
}
