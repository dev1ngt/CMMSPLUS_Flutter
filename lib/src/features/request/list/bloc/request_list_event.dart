

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class RequestListEvent extends Equatable {

  const RequestListEvent();
}

class RequestListLoadEvent extends RequestListEvent {
  final int propertyid, pageno;
  final String type, reqId;

  RequestListLoadEvent(this.propertyid, this.type, this.reqId, this.pageno);

  @override
  List<Object?> get props  =>[];

}