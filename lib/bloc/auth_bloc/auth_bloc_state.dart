part of 'auth_bloc_bloc.dart';

sealed class AuthBlocState extends Equatable {
  const AuthBlocState();

  @override
  List<Object> get props => [];
}

final class AuthBlocInitial extends AuthBlocState {}

class AuthBlocLoading extends AuthBlocState {}

class AuthBlocFailure extends AuthBlocState {
  final String message;
  const AuthBlocFailure({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class AuthBlocSuccess extends AuthBlocState {
  final AuthModel authModel;
  const AuthBlocSuccess({
    required this.authModel,
  });
  @override
  List<Object> get props => [authModel];
}
