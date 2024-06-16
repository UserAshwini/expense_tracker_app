part of 'get_incometype_bloc.dart';

sealed class GetIncometypeState extends Equatable {
  const GetIncometypeState();

  @override
  List<Object> get props => [];
}

final class GetIncometypeInitial extends GetIncometypeState {}

final class GetIncometypeFailure extends GetIncometypeState {}

final class GetIncometypeLoading extends GetIncometypeState {}

final class GetIncometypeSuccess extends GetIncometypeState {
  final List<IncomeType> incometype;

  const GetIncometypeSuccess(this.incometype);

  @override
  List<Object> get props => [incometype];
}
