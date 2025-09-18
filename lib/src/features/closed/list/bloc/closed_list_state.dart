import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../model/closed_list_model.dart';

@immutable
abstract class ClosedListState extends Equatable {}

class ClosedListInitialState extends ClosedListState {
  @override
  List<Object?> get props => [];
}

class ClosedListLoadedState extends ClosedListState {
  final List<ClosedData> closedList;

  ClosedListLoadedState(this.closedList);

  @override
  List<Object> get props => [closedList];
}

class ClosedListErrorState extends ClosedListState {
  final String error;

  ClosedListErrorState(this.error);

  @override
  List<Object> get props => [error];
}
