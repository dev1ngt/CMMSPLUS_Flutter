
import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'ppm_uploadfilesevent.dart';
import 'ppm_uploadfilesstate.dart';



class PPMUploadFilesBloc extends Bloc<PPMUploadFilesEvent, PPMUploadFilesState> {

  final ApiService fileUploadRepository;
  PPMUploadFilesBloc(this.fileUploadRepository) : super(PPMUploadFilesInitial()){
    on<PPMUploadInProgressEvent>((event, emit) {});
    on<PPMUploadFileInProgressEvent> ((event , emit) async{
      emit(PPMUploadInProgress());
      try{
        final upload_status = await
        fileUploadRepository.getPPMFileUploadStatus(ActualFileData: event.file,
           work_id: event.work_id , type: event.type );

        emit(PPMUploadFilesSuccess(upload_status));

      }catch(e){
        emit(PPMUploadFilesFailure(e.toString()));
      }

    });

  }




}