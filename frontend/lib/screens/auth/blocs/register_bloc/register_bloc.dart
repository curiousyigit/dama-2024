import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:weight_app/data/services/weight_app_service.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final WeightAppService _weightAppService;

  RegisterBloc(this._weightAppService) : super(RegisterInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(RegisterLoading());
      try {
        _weightAppService.acceptLang = event.acceptLang;
        await _weightAppService.register(
            event.name, event.email, event.password);
        emit(RegisterSuccess());
      } catch (e) {
        if (e is HTTPException) {
          if (e.statusCode == 422) {
            emit(RegisterRequestRejected.fromJson(e.jsonBody));
            return;
          }
        }
        emit(RegisterGenericFailure());
      }
    });
  }
}
