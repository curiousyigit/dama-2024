import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:weight_app/data/models/user.dart';
import 'package:weight_app/data/responses/users_response.dart';
import 'package:weight_app/data/services/weight_app_service.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final WeightAppService weightAppService;

  UsersBloc({required this.weightAppService}) : super(UsersInitial()) {
    on<LoadUsers>(_onLoadUsers);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    try {
      UsersResponse usersResponse = await weightAppService.getUsers(event.page);
      emit(UsersLoaded(
        users: usersResponse.users,
        currentPage: usersResponse.currentPage,
        lastPage: usersResponse.lastPage,
      ));
    } catch (e) {
      emit(UsersFailed(e.toString()));
    }
  }
}