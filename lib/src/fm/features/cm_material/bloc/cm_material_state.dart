

import 'package:flutter/cupertino.dart';

import '../model/cm_material_response_model.dart';


@immutable
sealed class CMMaterialStateI {}

final class CMMaterialInitial extends CMMaterialStateI {}

class CMMaterialLoading extends CMMaterialStateI{}

class CMMaterialSuccessState extends CMMaterialStateI {
  CMMaterialSuccessState(this.moduleResponse);
  CMMaterialModel moduleResponse;
}

class CMMaterialFailureState extends CMMaterialStateI {
  CMMaterialFailureState(this.materialError);
  String materialError = '';
}



