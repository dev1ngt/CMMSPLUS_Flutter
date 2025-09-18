import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class MyFaultlistEvent extends Equatable {
  const MyFaultlistEvent();
}

class MyFaultlistLoadEvent extends MyFaultlistEvent {
  final int pageNo;
  final String reqId;
  final String type;

  MyFaultlistLoadEvent(this.pageNo, this.reqId, this.type);

  @override
  List<Object?> get props => [];
}
