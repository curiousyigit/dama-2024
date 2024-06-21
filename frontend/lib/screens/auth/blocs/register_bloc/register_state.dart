part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}
final class RegisterRequestRejected extends RegisterState {
  final String message;
  final Map<String, List<String>> errors;

  const RegisterRequestRejected(this.message, this.errors);

  factory RegisterRequestRejected.fromJson(Map<String, dynamic> json) {
    final message = json['message'] as String? ?? 'Invalid request!';
    final errors = (json['errors'] as Map<String, dynamic>?)
        ?.map((key, value) => MapEntry(key, List<String>.from(value))) ?? {};
    return RegisterRequestRejected(message, errors);
  }

  @override
  List<Object> get props => [message, errors];
}
final class RegisterGenericFailure extends RegisterState {}
final class RegisterSuccess extends RegisterState {}
