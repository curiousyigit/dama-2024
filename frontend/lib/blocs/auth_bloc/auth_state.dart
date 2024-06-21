part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthUser? authUser;

  const AuthState._({required this.status, required this.authUser});

  const AuthState.authenticated(AuthUser authUser) : this._(status: AuthStatus.authenticated, authUser: authUser);

  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated, authUser: null);

  @override
  List<Object?> get props => [status, authUser];
}