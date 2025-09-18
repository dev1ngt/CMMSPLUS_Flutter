

import 'package:cmms/src/features/pendingresponsedetails/model/SubmitResponseModel.dart';
import 'package:flutter/cupertino.dart';

import '../../../cm_submit/model/submit_response_model.dart';
import '../model/ppm_barcode_response_model.dart';


@immutable
sealed class PPMBarcodeState {}

final class PPMBarcodeInitial extends PPMBarcodeState {}

class PPMBarcodeLoading extends PPMBarcodeState{}

class PPMBarcodeSuccessState extends PPMBarcodeState {
  PPMBarcodeSuccessState(this.moduleResponse);
  PPMBarcodeResponseModel moduleResponse;
}

class PPMBarcodeFailureState extends PPMBarcodeState {
  PPMBarcodeFailureState(this.loginError);
  String loginError = '';
}

/* Submit state*/


class DefectSubmitInProgress extends PPMBarcodeState {
}

class DefectSubmitLoaded extends PPMBarcodeState{
  DefectSubmitLoaded(this.complaintreg);
  final SubmitResponseModel complaintreg;
}

class DefectSubmitError extends PPMBarcodeState{
  DefectSubmitError(this.error);
  final String error;
}





