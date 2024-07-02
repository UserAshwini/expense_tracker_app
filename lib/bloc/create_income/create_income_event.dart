part of 'create_income_bloc.dart';

sealed class CreateIncomeEvent extends Equatable {
  const CreateIncomeEvent();

  @override
  List<Object> get props => [];
}

class CreateIncome extends CreateIncomeEvent {
  final Income income;
  final String uid;

  const CreateIncome(this.income, this.uid);

  @override
  List<Object> get props => [income, uid];
}
