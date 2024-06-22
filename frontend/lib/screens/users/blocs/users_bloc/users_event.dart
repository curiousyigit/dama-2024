part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

final class LoadUsers extends UsersEvent {
  final int page;

  LoadUsers(this.page);
}
