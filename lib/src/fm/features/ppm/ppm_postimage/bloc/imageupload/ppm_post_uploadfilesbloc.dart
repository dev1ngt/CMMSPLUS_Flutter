
import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'ppm_pre_uploadfilesevent.dart';
import 'ppm_pre_uploadfilesstate.dart';



class PPMPostUploadFilesBloc extends Bloc<PPMPostUploadFilesEvent, PPMPostUploadFilesState> {

  final ApiService fileUploadRepository;
  PPMPostUploadFilesBloc(this.fileUploadRepository) : super(PPMPostUploadFilesInitial()){
    on<PPMPostUploadInProgressEvent>((event, emit) {});
    on<PPMPostUploadFileInProgressEvent> ((event , emit) async{
      emit(PPMPostUploadInProgress());
      try{
        final upload_status = await
        fileUploadRepository.getPPMPostFileUploadStatus(ActualFileData: event.file,
           work_id: event.work_id , type: event.type );

        emit(PPMPostUploadFilesSuccess(upload_status));

      }catch(e){
        emit(PPMPostUploadFilesFailure(e.toString()));
      }

    });

  }




}