part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}
final class LoginRequestRejected extends LoginState {
  final String message;
  final Map<String, List<String>> errors;

  const LoginRequestRejected(this.message, this.errors);

  factory LoginRequestRejected.fromJson(Map<String, dynamic> json) {
    final message = json['message'] as String? ?? 'Invalid request!';
    final errors = (json['errors'] as Map<String, dynamic>?)
        ?.map((key, value) => MapEntry(key, List<String>.from(value))) ?? {};
    return LoginRequestRejected(message, errors);
  }

  @override
  List<Object> get props => [message, errors];
}
final class LoginGenericFailure extends LoginState {}
final class LoginSuccess extends LoginState {
  final AuthUser authUser;

  const LoginSuccess(this.authUser);

  @override
  List<Object> get props => [authUser];
}
