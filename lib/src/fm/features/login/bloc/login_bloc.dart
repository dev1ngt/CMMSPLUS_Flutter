import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';

import '../model/login_model.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService repository;

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginFetchEvent>((event, emit) {});
    on<LoginEvent>((event, emit) {});
    on<LoginClickEvent>((event, emit) async {
      await loginUser(event.loginData, emit);
    });



  }

  loginUser(LoginInputFM loginInputModel, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final response =
          await repository.postUserLoginFM(loginInput: loginInputModel);

      emit(LoginSuccessState(response));
    } catch (e) {
      print(e.toString());
      emit(LoginFailureState(e.toString()));
    }
  }
}
