


import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class NotificationUpdateEvent extends Equatable {

  const NotificationUpdateEvent();
}

class NotificationLoadUpdateEvent extends NotificationUpdateEvent {

  NotificationLoadUpdateEvent();

  @override
  List<Object?> get props  =>[];

}


class NotificationListUpdateEvent extends NotificationUpdateEvent {
  final int notifyid;

  NotificationListUpdateEvent(this.notifyid);

  @override
  List<Object?> get props  =>[];

}