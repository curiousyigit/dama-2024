part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterRequested extends RegisterEvent {
  final String acceptLang;
  final String name;
  final String email;
  final String password;

  const RegisterRequested(this.acceptLang, this.name, this.email, this.password);

  @override
  List<Object> get props => [acceptLang, name, email, password];
}
