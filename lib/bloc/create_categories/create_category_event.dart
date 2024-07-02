import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/models/caregory.dart';

sealed class CreateCategoryEvent extends Equatable {
  const CreateCategoryEvent();

  @override
  List<Object> get props => [];
}

class CreateCategory extends CreateCategoryEvent {
  final Category category;
  final String uid;

  const CreateCategory(this.category, this.uid);

  @override
  List<Object> get props => [category, uid];
}
