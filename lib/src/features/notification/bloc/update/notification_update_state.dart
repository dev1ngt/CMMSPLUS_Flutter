



import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../pendingresponsedetails/model/SubmitResponseModel.dart';

@immutable
abstract class NotificationUpdateState extends Equatable {

}

class NotificationUpdateInitialState extends NotificationUpdateState {
  @override
  List<Object?> get props => [];
}

class NotificationUpdateLoadedState extends NotificationUpdateState {
  final SubmitResponseModel submitResponseModel;
  NotificationUpdateLoadedState(this.submitResponseModel);

  @override
  List<Object> get props => [submitResponseModel];
}

class NotificationUpdateErrorState extends NotificationUpdateState {
  final String error;

  NotificationUpdateErrorState(this.error);

  @override
  List<Object> get props => [error];
}