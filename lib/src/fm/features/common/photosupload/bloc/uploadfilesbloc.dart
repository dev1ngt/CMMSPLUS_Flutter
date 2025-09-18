
import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'uploadfilesevent.dart';
import 'uploadfilesstate.dart';



class UploadFilesBloc extends Bloc<UploadFilesEvent, UploadFilesState> {

  final ApiService fileUploadRepository;
  UploadFilesBloc(this.fileUploadRepository) : super(UploadFilesInitial()){
    on<UploadInProgressEvent>((event, emit) {});
    on<UploadFileInProgressEvent> ((event , emit) async{
      emit(UploadInProgress());
      try{
        final upload_status = await
        fileUploadRepository.getFileUploadStatusFM(ActualFileData: event.file,
           work_id: event.work_id , type: event.type );

        emit(UploadFilesSuccess(upload_status));

      }catch(e){
        emit(UploadFilesFailure(e.toString()));
      }

    });

  }




}