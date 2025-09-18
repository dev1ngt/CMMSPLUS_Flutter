

import 'package:flutter/cupertino.dart';

import '../model/ppm_list_response_model.dart';

@immutable
sealed class PPMListMyState {}

class PPMListInitial extends PPMListMyState {}


class PPMListLoaded extends PPMListMyState{
  PPMListLoaded(this.ppmlist);
  final PPMListResponseModel ppmlist;

}

class PPMListError extends PPMListMyState{
  PPMListError(this.error);
  final String error;
}
