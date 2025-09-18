
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../api/api_service.dart';
import 'UploadFilesEvent.dart';
import 'UploadFilesState.dart';



class UploadFilesBloc extends Bloc<UploadFilesEvent, UploadFilesState> {

  final ApiService fileUploadRepository;
  UploadFilesBloc(this.fileUploadRepository) : super(UploadFilesInitial()){
    on<UploadInProgressEvent>((event, emit) {});
    on<UploadFileInProgressEvent> ((event , emit) async{
      emit(UploadFilesInitial());
      try{
        final upload_status = await
        fileUploadRepository.getFileUploadStatus(ActualFileData: event.file,
            FileName: event.FileName);

        emit(UploadFilesSuccess(upload_status));

      }catch(e){
        emit(UploadFilesFailure(e.toString()));
      }

    });

  }

}