part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends LoginEvent {
  final String acceptLang;
  final String email;
  final String password;

  const LoginRequested(this.acceptLang, this.email, this.password);

  @override
  List<Object> get props => [acceptLang, email, password];
}

class LogoutRequested extends LoginEvent {}