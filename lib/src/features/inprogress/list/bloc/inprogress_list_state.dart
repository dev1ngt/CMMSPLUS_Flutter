
import 'package:cmms/src/features/inprogress/list/model/inprogress_list_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';



@immutable
abstract class InProgressListState extends Equatable {

}

class InProgressListLoadingState extends InProgressListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InProgressListLoadedState extends InProgressListState {
  final List<InProgressData> inProgressList;

  InProgressListLoadedState(this.inProgressList);

  @override
  // TODO: implement props
  List<Object?> get props => [inProgressList];
}

class InProgressListErrorState extends InProgressListState {
  final String error;

  InProgressListErrorState(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}