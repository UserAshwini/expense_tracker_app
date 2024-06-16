import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/models/caregory.dart';

sealed class GetCategoriesState extends Equatable {
  const GetCategoriesState();

  @override
  List<Object> get props => [];
}

final class GetCategoriesInitial extends GetCategoriesState {}

final class GetCategoriesFailure extends GetCategoriesState {}

final class GetCategoriesLoading extends GetCategoriesState {}

final class GetCategoriesSuccess extends GetCategoriesState {
  final List<Category> categories;

  const GetCategoriesSuccess(this.categories);

  @override
  List<Object> get props => [categories];
}
