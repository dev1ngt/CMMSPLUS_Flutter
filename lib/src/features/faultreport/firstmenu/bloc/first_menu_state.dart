

import 'package:flutter/cupertino.dart';

import '../model/request_type.dart';

@immutable
sealed class FRFirstMenuState {}

class FRFirstMenuInitial extends FRFirstMenuState {}


class FRFirstMenuLoaded extends FRFirstMenuState{
  FRFirstMenuLoaded(this.ppmlist);
  final RequestType ppmlist;

}

class FRFirstMenuError extends FRFirstMenuState{
  FRFirstMenuError(this.error);
  final String error;
}
