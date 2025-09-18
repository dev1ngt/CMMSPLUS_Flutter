
import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;


import 'cm_submit_event.dart';
import 'cm_submit_state.dart';



class CMSubmitBloc extends Bloc<CMSubmitEvent, CMSubmitState> {

  final ApiService fileUploadRepository;


  CMSubmitBloc(this.fileUploadRepository) : super(CMSubmitInitial()){
    on<CMSubmitInitEvent>((event, emit) {});
    on<CMSubmitInProgressEvent> ((event , emit) async{
      emit(CMSubmitInProgress());
      try{
        final upload_status = await
        fileUploadRepository.postCMSubmit(submitmodel: event.submitRequestModel );

        emit(CMSubmitSuccess(upload_status));

      }catch(e){
        emit(CMSubmitFailure(e.toString()));
      }

    });

  }





}