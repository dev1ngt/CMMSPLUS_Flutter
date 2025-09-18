
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/api_service.dart';
import 'logger_event.dart';
import 'logger_state.dart';


class LoggerBloc extends Bloc<LoggerEvent, LoggerState> {
  //final DashboardRepository repository;
  final ApiService repository;

  LoggerBloc(this.repository) : super(LoggerLoadingState()) {
    on<LoadLoggerEvent>((event, emit) async {
      emit(LoggerLoadingState());
      print("You emitted first state test");
      try {
        final logger = await repository.postLogger(logger: event.loginData);
        emit(LoggerLoadedState(logger));
      } catch (e) {
        emit(LoggerErrorState(e.toString()));
      }
    });
  }
}