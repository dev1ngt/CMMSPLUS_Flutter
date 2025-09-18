
import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'ppm_submit_event.dart';
import 'ppm_submit_state.dart';



class PPMSubmitBloc extends Bloc<PPMSubmitEvent, PPMSubmitState> {

  final ApiService fileUploadRepository;


  PPMSubmitBloc(this.fileUploadRepository) : super(PPMSubmitInitial()){
    on<PPMSubmitInitEvent>((event, emit) {});
    on<PPMSubmitInProgressEvent> ((event , emit) async{
      emit(PPMSubmitInProgress());
      try{
        final upload_status = await
        fileUploadRepository.postPPMSubmit(ppmSubmitRequestModel: event.submitRequestModel);

        emit(PPMSubmitSuccess(upload_status));

      }catch(e){
        emit(PPMSubmitFailure(e.toString()));
      }

    });

  }





}