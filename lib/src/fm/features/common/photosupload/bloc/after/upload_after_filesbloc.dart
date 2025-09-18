
import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'upload_after_filesevent.dart';
import 'upload_after_filesstate.dart';



class UploadAfterFilesBloc extends Bloc<UploadAfterFilesEvent, UploadAfterFilesState> {

  final ApiService fileUploadRepository;


  UploadAfterFilesBloc(this.fileUploadRepository) : super(UploadAfterFilesInitial()){
    on<UploadAfterInProgressEvent>((event, emit) {});
    on<UploadAfterFileInProgressEvent> ((event , emit) async{
      emit(UploadAfterInProgress());
      try{
        final upload_status = await
        fileUploadRepository.getAfterFileUploadStatus(ActualFileData: event.file,
            work_id: event.work_id , type: event.type );

        emit(UploadAfterFilesSuccess(upload_status));

      }catch(e){
        emit(UploadAfterFilesFailure(e.toString()));
      }

    });

  }





}