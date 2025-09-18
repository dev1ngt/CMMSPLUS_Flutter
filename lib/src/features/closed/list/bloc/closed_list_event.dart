import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class ClosedListEvent extends Equatable {
  const ClosedListEvent();
}

class FetchClosedListEvent extends ClosedListEvent {
  final int propertyid, pageno;
  final String reqId;

  FetchClosedListEvent(this.propertyid, this.pageno, this.reqId);

  @override
  List<Object?> get props => [];
}
