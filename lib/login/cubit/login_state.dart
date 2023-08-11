part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccessful extends LoginState {
  @override
  List<Object?> get props => [];
}

class ErrorInAuthentication extends LoginState {
  String errorMessage;
  ErrorInAuthentication(this.errorMessage);
  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoggedOut extends LoginState {
  @override
  List<Object?> get props => [];
}
