part of 'auth_bloc_bloc.dart';

sealed class AuthBlocEvent extends Equatable {
  const AuthBlocEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthBlocEvent {}

class AuthenticationStateChanged extends AuthBlocEvent {
  final AuthModel authModel;
  const AuthenticationStateChanged({
    required this.authModel,
  });
  @override
  List<Object> get props => [authModel];
}

class AuthenticationGoogleStarted extends AuthBlocEvent {}

class AuthenticationExited extends AuthBlocEvent {}
