part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthInitialized extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final AuthUser? authUser;

  const AuthUserChanged(this.authUser);
}

class AuthLogoutRequested extends AuthEvent {}
