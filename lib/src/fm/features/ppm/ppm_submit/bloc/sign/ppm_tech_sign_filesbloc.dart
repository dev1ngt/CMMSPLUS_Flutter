
import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'ppm_tech_sign_filesevent.dart';
import 'ppm_tech_sign_filesstate.dart';



class PPMTechSignFileBloc extends Bloc<PPMTechSignFileEvent, PPMTechSignFileState> {

  final ApiService fileUploadRepository;


  PPMTechSignFileBloc(this.fileUploadRepository) : super(PPMTechSignFileInitial()){
    on<PPMTechSignFileInitEvent>((event, emit) {});
    on<PPMTechSignFileInProgressEvent> ((event , emit) async{
      emit(PPMTechSignFileInProgress());
      try{
        final upload_status = await
        fileUploadRepository.getPPMTechSignStatus(ActualFileData: event.file,
            work_id: event.work_id , type: event.type );

        emit(PPMTechSignFileSuccess(upload_status));

      }catch(e){
        emit(PPMTechSignFileFailure(e.toString()));
      }

    });

  }





}