import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../myfaultreport/list/model/myfault_list_model.dart';



@immutable
abstract class MyFaultlistState extends Equatable {}

class MyFaultlistInitialState extends MyFaultlistState {
  @override
  List<Object?> get props => [];
}

class MyFaultlistLoadedState extends MyFaultlistState {
  final List<RequestData1> closedList;

  MyFaultlistLoadedState(this.closedList);

  @override
  List<Object> get props => [closedList];
}

class MyFaultlistErrorState extends MyFaultlistState {
  final String error;

  MyFaultlistErrorState(this.error);

  @override
  List<Object> get props => [error];
}
