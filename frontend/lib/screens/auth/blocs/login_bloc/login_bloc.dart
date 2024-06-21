import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weight_app/data/models/auth_user.dart';

import 'package:weight_app/data/services/weight_app_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final WeightAppService _weightAppService;

  LoginBloc(this._weightAppService) : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      try {
        _weightAppService.acceptLang = event.acceptLang;
        final authUser = await _weightAppService.login(event.email, event.password);
        emit(LoginSuccess(authUser));
      } catch (e) {
        if (e is HTTPException) {
          if (e.statusCode == 422) {
            emit(LoginRequestRejected.fromJson(e.jsonBody));
            return;
          }
        }
        emit(LoginGenericFailure());
      }
    });
    on<LogoutRequested>((event, emit) async => await _weightAppService.logout());
  }
}
