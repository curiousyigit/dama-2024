part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

final class UsersInitial extends UsersState {}

final class UsersLoading extends UsersState {}

final class UsersLoaded extends UsersState {
  final List<User> users;
  final int currentPage;
  final int lastPage;

  UsersLoaded({
    required this.users,
    required this.currentPage,
    required this.lastPage,
  });
}

final class UsersFailed extends UsersState {
  final String error;

  UsersFailed(this.error);
}
