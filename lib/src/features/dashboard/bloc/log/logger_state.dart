

import '../../model/log/logger_model_response.dart';

sealed class LoggerState {}

class LoggerLoadingState extends LoggerState {}

class LoggerLoadedState extends LoggerState {
  final LoggerModelResponse loggerdata;

  LoggerLoadedState(this.loggerdata);

}

class LoggerErrorState extends LoggerState {
  final String errorMessage;

  LoggerErrorState(this.errorMessage);
}