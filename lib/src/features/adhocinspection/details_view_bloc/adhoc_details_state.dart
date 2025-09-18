

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../model/adhoc_details_view_model.dart';


@immutable
abstract class AdhocDetailsViewState extends Equatable {

}

class AdhocDetailsViewInitialState extends AdhocDetailsViewState {
  @override
  List<Object?> get props => [];
}

class AdhocDetailsViewLoadingState extends AdhocDetailsViewState {
  @override
  List<Object?> get props => [];
}

class AdhocDetailsViewLoadedState extends AdhocDetailsViewState {
  AdhocDetailsViewModel adhocDetailsViewModel ;

  AdhocDetailsViewLoadedState(this.adhocDetailsViewModel);

  @override
  List<Object> get props => [adhocDetailsViewModel];
}

class AdhocDetailsViewErrorState extends AdhocDetailsViewState {
  final String error;

  AdhocDetailsViewErrorState(this.error);

  @override
  List<Object> get props => [error];
}