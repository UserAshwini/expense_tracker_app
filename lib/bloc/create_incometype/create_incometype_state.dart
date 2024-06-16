part of 'create_incometype_bloc.dart';

sealed class CreateIncometypeState extends Equatable {
  const CreateIncometypeState();

  @override
  List<Object> get props => [];
}

final class CreateIncometypeInitial extends CreateIncometypeState {}

final class CreateIncometypeFailure extends CreateIncometypeState {}

final class CreateIncometypeLoading extends CreateIncometypeState {}

final class CreateIncometypeSuccess extends CreateIncometypeState {}
