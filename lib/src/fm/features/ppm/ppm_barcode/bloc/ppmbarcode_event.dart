
import 'package:flutter/cupertino.dart';

import '../model/ppm_barcode_response_model.dart';





@immutable
sealed class PPMBarcodeEvent {}

class PPMBarcodeFetchEvent extends PPMBarcodeEvent{
  String ppmID;
  PPMBarcodeFetchEvent(this.ppmID);
}

class DefectSubmitEvent extends PPMBarcodeEvent{
  DefectSubmitEvent(this.defectSubmitInput);
  SubmitDefectInput defectSubmitInput = SubmitDefectInput();
}
