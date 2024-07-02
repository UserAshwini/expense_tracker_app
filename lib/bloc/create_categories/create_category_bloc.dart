import 'package:expense_tracker_app/bloc/create_categories/create_category_event.dart';
import 'package:expense_tracker_app/bloc/create_categories/create_category_state.dart';
import 'package:expense_tracker_app/repoitories/expense_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCategoryBloc
    extends Bloc<CreateCategoryEvent, CreateCategoryState> {
  final ExpenseRepository expenseRepository;

  CreateCategoryBloc(this.expenseRepository) : super(CreateCategoryInitial()) {
    on<CreateCategory>((event, emit) async {
      emit(CreateCategoryLoading());
      try {
        await expenseRepository.createEmptyCategories(
            event.uid, event.category);
        emit(CreateCategorySuccess());
      } catch (e) {
        emit(CreateCategoryFailure());
      }
    });
  }
}
