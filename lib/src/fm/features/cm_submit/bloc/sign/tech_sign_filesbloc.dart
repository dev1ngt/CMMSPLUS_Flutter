
import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;


import 'tech_sign_filesevent.dart';
import 'tech_sign_filesstate.dart';



class TechSignFileBloc extends Bloc<TechSignFileEvent, TechSignFileState> {

  final ApiService fileUploadRepository;


  TechSignFileBloc(this.fileUploadRepository) : super(TechSignFileInitial()){
    on<TechSignFileInitEvent>((event, emit) {});
    on<TechSignFileInProgressEvent> ((event , emit) async{
      emit(TechSignFileInProgress());
      try{
        final upload_status = await
        fileUploadRepository.getTechSignStatus(ActualFileData: event.file,
            work_id: event.work_id , type: event.type );

        emit(TechSignFileSuccess(upload_status));

      }catch(e){
        emit(TechSignFileFailure(e.toString()));
      }

    });

  }





}