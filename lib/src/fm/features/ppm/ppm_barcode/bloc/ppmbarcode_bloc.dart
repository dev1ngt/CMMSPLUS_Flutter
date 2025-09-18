import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/api/api_service.dart';

import 'ppmbarcode_event.dart';
import 'ppmbarcode_state.dart';

class PPMBarcodeBloc extends Bloc<PPMBarcodeEvent, PPMBarcodeState> {
  final ApiService repository;
  PPMBarcodeBloc(this.repository) : super(PPMBarcodeInitial()) {

    on<PPMBarcodeFetchEvent>((event, emit) async {
      emit(PPMBarcodeLoading());
      try{
        final upload_status = await repository.getPPMBarcode(ppmid: event.ppmID);
        emit(PPMBarcodeSuccessState(upload_status));
      }catch(e){
        emit(PPMBarcodeFailureState(e.toString()));
        print(e);
      }
    });

    /* Submit defect */

    on<DefectSubmitEvent>((event, emit) async {
      emit(DefectSubmitInProgress());
      try{
        final upload_status = await repository.postDefectSubmit(submitDefectInput: event.defectSubmitInput);
        emit(DefectSubmitLoaded(upload_status));
      }catch(e){
        emit(DefectSubmitError(e.toString()));
        print(e);
      }
    });



  }
}
