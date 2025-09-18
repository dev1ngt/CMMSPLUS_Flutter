


import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../pendingresponsedetails/model/SubmitResponseModel.dart';
import '../model/notification_list_model.dart';

@immutable
abstract class NotificationListState extends Equatable {

}

class NotificationListInitialState extends NotificationListState {
  @override
  List<Object?> get props => [];
}

class NotificationListLoadedState extends NotificationListState {
  final Map<String, List<NotificationItem>> notificationList;
  NotificationListLoadedState(this.notificationList);
  @override
  List<Object> get props => [notificationList];
}

class NotificationListErrorState extends NotificationListState {
  final String error;
  NotificationListErrorState(this.error);
  @override
  List<Object> get props => [error];
}

class NotificationClearLoadingState extends NotificationListState {
  @override
  List<Object?> get props => [];
}

class NotificationClearSuccessState extends NotificationListState {
  final String message;

  NotificationClearSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationClearErrorState extends NotificationListState {
  final String error;

  NotificationClearErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
