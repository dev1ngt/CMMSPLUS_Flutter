import 'package:cmms/src/features/dashboard/model/log/logger_model_response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class LoggerEvent {}

 class LoggerFetchevent extends LoggerEvent{
   LoggerFetchevent();

}

class LoadLoggerEvent extends LoggerEvent {

  LoadLoggerEvent(this.loginData);
  LoggerInput loginData = LoggerInput();
}