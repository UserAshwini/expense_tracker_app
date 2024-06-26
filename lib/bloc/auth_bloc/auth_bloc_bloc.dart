import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/models/auth_model.dart';
import 'package:expense_tracker_app/repoitories/auth_repository.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthenticationBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<AuthModel>? authStreamSub;

  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(AuthBlocInitial()) {
    on<AuthenticationStarted>(_onAuthenticationStarted);
    on<AuthenticationStateChanged>(_onAuthenticationStateChanged);
    on<AuthenticationGoogleStarted>(_onAuthenticationGoogleStarted);
    on<AuthenticationExited>(_onAuthenticationExited);
  }

  Future<void> _onAuthenticationStarted(
    AuthenticationStarted event,
    Emitter<AuthBlocState> emit,
  ) async {
    try {
      emit(AuthBlocLoading());
      authStreamSub =
          _authenticationRepository.getAuthDetailStream().listen((authModel) {
        add(AuthenticationStateChanged(authModel: authModel));
      });
    } catch (error) {
      print(
          'Error occurred while fetching authentication detail: ${error.toString()}');
      emit(const AuthBlocFailure(
          message: 'Error occurred while fetching auth detail'));
    }
  }

  void _onAuthenticationStateChanged(
    AuthenticationStateChanged event,
    Emitter<AuthBlocState> emit,
  ) {
    if (event.authModel.isValid!) {
      emit(AuthBlocSuccess(authModel: event.authModel));
    } else {
      emit(const AuthBlocFailure(message: 'User has logged out'));
    }
  }

  Future<void> _onAuthenticationGoogleStarted(
    AuthenticationGoogleStarted event,
    Emitter<AuthBlocState> emit,
  ) async {
    try {
      emit(AuthBlocLoading());
      AuthModel authModel =
          await _authenticationRepository.authenticateWithGoogle();

      if (authModel.isValid!) {
        emit(AuthBlocSuccess(authModel: authModel));
      } else {
        emit(const AuthBlocFailure(message: 'User detail not found.'));
      }
    } catch (error) {
      print('Error occurred while login with Google: ${error.toString()}');
      emit(const AuthBlocFailure(
          message: 'Unable to login with Google. Try again.'));
    }
  }

  Future<void> _onAuthenticationExited(
    AuthenticationExited event,
    Emitter<AuthBlocState> emit,
  ) async {
    try {
      emit(AuthBlocLoading());
      await _authenticationRepository.unAuthenticate();
      emit(AuthBlocInitial());
    } catch (error) {
      print('Error occurred while logging out: ${error.toString()}');
      emit(const AuthBlocFailure(
          message: 'Unable to logout. Please try again.'));
    }
  }

  @override
  Future<void> close() {
    authStreamSub?.cancel();
    return super.close();
  }
}
