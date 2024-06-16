part of 'create_incometype_bloc.dart';

sealed class CreateIncometypeEvent extends Equatable {
  const CreateIncometypeEvent();

  @override
  List<Object> get props => [];
}

class CreateIncometype extends CreateIncometypeEvent {
  final IncomeType incometype;

  const CreateIncometype(this.incometype);

  @override
  List<Object> get props => [incometype];
}
