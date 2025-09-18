


import 'package:flutter/cupertino.dart';
import '../model/location_response.dart';

@immutable
sealed class FRFourthLocationState {}

class FRFourthLocationInitial extends FRFourthLocationState {}


class FRFourthLocationLoaded extends FRFourthLocationState{
  FRFourthLocationLoaded(this.locationlist);
  final LocationResponse locationlist;

}

class FRFourthLocationError extends FRFourthLocationState{
  FRFourthLocationError(this.error);
  final String error;
}



