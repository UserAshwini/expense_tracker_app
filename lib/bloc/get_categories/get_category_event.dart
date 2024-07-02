import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/models/caregory.dart';

sealed class GetCategoriesEvent extends Equatable {
  const GetCategoriesEvent();

  @override
  List<Object> get props => [];
}

class GetCategories extends GetCategoriesEvent {
  final String uid;

  const GetCategories(this.uid);
  @override
  List<Object> get props => [uid];
}

class DeleteCategory extends GetCategoriesEvent {
  final String categoryId;
  final String uid;

  const DeleteCategory(this.categoryId, this.uid);
}

class UpdateCategory extends GetCategoriesEvent {
  final Category category;
  final String uid;

  const UpdateCategory(this.category, this.uid);
}
