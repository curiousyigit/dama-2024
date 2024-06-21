import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weight_app/data/models/auth_user.dart';
import 'package:weight_app/data/services/weight_app_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final WeightAppService weightAppService;
  SharedPreferences? prefs;

  AuthBloc({required this.weightAppService}) : super(const AuthState.unauthenticated()) {
    on<AuthInitialized>((event, emit) async {
      prefs ??= await SharedPreferences.getInstance();

      final String? memoryAuthUserStr = prefs!.getString('authUser');
      final String? memoryToken = prefs!.getString('token');

      if (memoryToken != null && memoryAuthUserStr != null) {
        try {
          weightAppService.token = memoryToken;
          weightAppService.authUser = AuthUser.fromJson(jsonDecode(memoryAuthUserStr));
          emit(AuthState.authenticated(weightAppService.authUser!));
          return;
        } catch (e) {
          await prefs!.remove('authUser');
          await prefs!.remove('token');
        }
        
      }

      emit(const AuthState.unauthenticated());
    });

    on<AuthUserChanged>((event, emit) async {
      if (event.authUser != null) {
        await prefs!.setString('authUser', jsonEncode(event.authUser!.toJson()));
        await prefs!.setString('token', weightAppService.token!);
        emit(AuthState.authenticated(event.authUser!));
      } else {
        await prefs!.remove('authUser');
        await prefs!.remove('token');
        emit(const AuthState.unauthenticated());
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      await weightAppService.logout();
      await prefs!.remove('authUser');
      await prefs!.remove('token');
      emit(const AuthState.unauthenticated());
    });
  }
}