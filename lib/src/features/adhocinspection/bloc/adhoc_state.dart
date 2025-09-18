import 'package:cmms/src/features/adhocinspection/model/adhoc_list_response_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class AdhocListMyState {}

class AdhocListInitial extends AdhocListMyState {}

class AdhocListLoaded extends AdhocListMyState {
  AdhocListLoaded(this.adhoclist);

  final AdhocListResponseModel adhoclist;
}

class AdhocListError extends AdhocListMyState {
  AdhocListError(this.error);

  final String error;
}
