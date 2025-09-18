
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../model/request_list_model.dart';

@immutable
abstract class RequestListState extends Equatable {

}

class RequestListInitialState extends RequestListState {
  @override
  List<Object?> get props => [];
}

class RequestListLoadedState extends RequestListState {
  final List<RequestData> closedList;

  RequestListLoadedState(this.closedList);

  @override
  List<Object> get props => [closedList];
}

class RequestListErrorState extends RequestListState {
  final String error;

  RequestListErrorState(this.error);

  @override
  List<Object> get props => [error];
}