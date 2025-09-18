import 'dart:convert';

import 'package:bloc/bloc.dart';

import 'package:cmms/src/features/login/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_service.dart';
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
    on<ForgotPasswordClickEvent>((event, emit) async{
      emit(ForgotPassInitialState());
      try {
        final response = await repository.getForgotPasswordAPI(mail: event.email);

        if (response.isError) {
          emit(ForgotPassLoadedState(response));
        } else {
          emit(ForgotPassLoadedState(response));
        }
      } catch (e) {
        emit(ForgotPassErrorState(e.toString()));
      }

    });


  }

  loginUser(LoginInput loginInputModel, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final response =
          await repository.postUserLogin(loginInput: loginInputModel);

      emit(LoginSuccessState(response));
    } catch (e) {
      emit(LoginFailureState(e.toString()));
    }
  }
}
