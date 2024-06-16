part of 'get_incometype_bloc.dart';

sealed class GetIncometypeEvent extends Equatable {
  const GetIncometypeEvent();

  @override
  List<Object> get props => [];
}

class GetIncometype extends GetIncometypeEvent {}
