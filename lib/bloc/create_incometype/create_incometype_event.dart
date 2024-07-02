part of 'create_incometype_bloc.dart';

sealed class CreateIncometypeEvent extends Equatable {
  const CreateIncometypeEvent();

  @override
  List<Object> get props => [];
}

class CreateIncometype extends CreateIncometypeEvent {
  final IncomeType incometype;
  final String uid;

  const CreateIncometype(this.incometype, this.uid);

  @override
  List<Object> get props => [incometype, uid];
}
