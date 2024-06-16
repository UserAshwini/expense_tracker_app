import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/models/caregory.dart';

sealed class CreateCategoryEvent extends Equatable {
  const CreateCategoryEvent();

  @override
  List<Object> get props => [];
}

class CreateCategory extends CreateCategoryEvent {
  final Category category;

  const CreateCategory(this.category);

  @override
  List<Object> get props => [category];
}
