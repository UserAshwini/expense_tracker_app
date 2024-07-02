import 'package:expense_tracker_app/bloc/get_categories/get_category_event.dart';
import 'package:expense_tracker_app/bloc/get_categories/get_category_state.dart';
import 'package:expense_tracker_app/models/caregory.dart';
import 'package:expense_tracker_app/repoitories/expense_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  ExpenseRepository expenseRepository;

  GetCategoriesBloc(this.expenseRepository) : super(GetCategoriesInitial()) {
    on<GetCategories>((event, emit) async {
      emit(GetCategoriesLoading());
      try {
        List<Category> categories =
            await expenseRepository.getCategories(event.uid);
        emit(GetCategoriesSuccess(categories));
      } catch (e) {
        emit(GetCategoriesFailure());
      }
    });
    on<DeleteCategory>((event, emit) async {
      try {
        await expenseRepository.deleteCategory(event.categoryId, event.uid);
        // Re-fetch the categories after deletion
        List<Category> categories =
            await expenseRepository.getCategories(event.uid);
        emit(GetCategoriesSuccess(categories));
      } catch (e) {
        print("Error in DeleteCategory: $e");
        emit(GetCategoriesFailure());
      }
    });
    on<UpdateCategory>((event, emit) async {
      try {
        await expenseRepository.updateCategory(event.category, event.uid);
        // Re-fetch the categories after update
        List<Category> categories =
            await expenseRepository.getCategories(event.uid);
        emit(GetCategoriesSuccess(categories));
      } catch (e) {
        print("Error in UpdateCategory: $e");
        emit(GetCategoriesFailure());
      }
    });
  }
}
