


import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class NotificationListEvent extends Equatable {

  const NotificationListEvent();
}

class NotificationListLoadEvent extends NotificationListEvent {

  NotificationListLoadEvent();

  @override
  List<Object?> get props  =>[];

}

class NotificationClearEvent extends NotificationListEvent {
  final int isRead; // 0 = unread, 1 = read

  const NotificationClearEvent(this.isRead);

  @override
  List<Object?> get props => [isRead];
}

