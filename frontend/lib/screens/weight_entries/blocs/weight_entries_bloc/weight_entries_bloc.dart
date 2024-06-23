import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:weight_app/data/models/weight_entry.dart';
import 'package:weight_app/data/responses/weight_entries_response.dart';
import 'package:weight_app/data/services/weight_app_service.dart';

part 'weight_entries_event.dart';
part 'weight_entries_state.dart';

class WeightEntriesBloc extends Bloc<WeightEntriesEvent, WeightEntriesState> {
  final WeightAppService weightAppService;

  WeightEntriesBloc({required this.weightAppService})
      : super(const WeightEntriesState()) {
    on<GetWeightEntries>(_onGetWeightEntries);
    on<CreateWeightEntry>(_onCreateWeightEntries);
    on<UpdateWeightEntry>(_onUpdateWeightEntries);
    on<DeleteWeightEntry>(_onDeleteWeightEntries);
    on<ClearErrors>(_onClearErrors);
  }

  Future<void> _onGetWeightEntries(event, emit) async {
    try {
      emit(state.copyWith(loading: true));

      WeightEntriesResponse weightEntriesResponse =
          await weightAppService.getWeightEntries(event.page);

      emit(
        state.copyWithoutErrors(
          weightEntries: [
            if (event.append) ...state.weightEntries,
            ...weightEntriesResponse.weightEntries,
          ],
          currentPage: weightEntriesResponse.currentPage,
          lastPage: weightEntriesResponse.lastPage,
          hasReachedMax: weightEntriesResponse.currentPage ==
              weightEntriesResponse.lastPage,
          loading: false,
        ),
      );
    } catch (e) {
      if (e is HTTPException) {
        emit(state.copyWith(
          loading: false,
          errorMsg: e.jsonBody['message'] ?? 'Request Failed',
          errors: (e.jsonBody['errors'] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, List<String>.from(value))) ?? {},
        ));
      }

      log(e.toString());
    }
  }

  Future<void> _onCreateWeightEntries(event, emit) async {
    try {
      emit(state.copyWith(loading: true));

      WeightEntry newWeightEntry =
          await weightAppService.createWeightEntry(event.kg, event.notes);

      emit(state.copyWithoutErrors(
        weightEntries: [newWeightEntry, ...state.weightEntries],
        loading: false,
      ));
    } catch (e) {
      if (e is HTTPException) {
        emit(state.copyWith(
          loading: false,
          errorMsg: e.jsonBody['message'],
          errors: (e.jsonBody['errors'] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, List<String>.from(value))) ?? {},
        ));
      }

      log(e.toString());
    }
  }

  Future<void> _onUpdateWeightEntries(event, emit) async {
    try {
      emit(state.copyWith(loading: true));

      WeightEntry updatedWeightEntry = await weightAppService.updateWeightEntry(
          event.id, event.kg, event.notes);

      final index =
          state.weightEntries.map((wE) => wE.id).toList().indexOf(event.id);

      final updatedWeightEntries = [...state.weightEntries];
      if (index >= 0) {
        updatedWeightEntries[index] = updatedWeightEntry;
      }

      emit(state.copyWithoutErrors(
        weightEntries: updatedWeightEntries,
        loading: false,
      ));
    } catch (e) {
      if (e is HTTPException) {
        emit(state.copyWith(
          loading: false,
          errorMsg: e.jsonBody['message'] ?? 'Request Failed',
          errors: (e.jsonBody['errors'] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, List<String>.from(value))) ?? {},
        ));
      }

      log(e.toString());
    }
  }

  Future<void> _onDeleteWeightEntries(event, emit) async {
    try {
      emit(state.copyWith(loading: true));

      await weightAppService.deleteWeightEntry(event.id);

      final index =
          state.weightEntries.map((wE) => wE.id).toList().indexOf(event.id);
      final updatedWeightEntries = [...state.weightEntries];
      updatedWeightEntries.removeAt(index);

      emit(state.copyWithoutErrors(
        weightEntries: updatedWeightEntries,
        loading: false,
      ));
    } catch (e) {
      if (e is HTTPException) {
        emit(state.copyWith(
          loading: false,
          errorMsg: e.jsonBody['message'] ?? 'Request Failed',
          errors: (e.jsonBody['errors'] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, List<String>.from(value))) ?? {},
        ));
      }

      log(e.toString());
    }
  }

  Future<void> _onClearErrors(event, emit) async {
    emit(state.copyWithoutErrors());
  }
}
