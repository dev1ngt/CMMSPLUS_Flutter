
import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'occupant_filesevent.dart';
import 'occupant_filesstate.dart';



class OccuapntSignFilesBloc extends Bloc<OccuapntSignFilesEvent, OccupantSignFilesState> {

  final ApiService fileUploadRepository;


  OccuapntSignFilesBloc(this.fileUploadRepository) : super(OccupantSignFilesInitial()){
    on<OccuapntSignInProgressEvent>((event, emit) {});
    on<OccuapntSignFileInProgressEvent> ((event , emit) async{
      emit(OccupantSignInProgress());
      try{
        final upload_status = await
        fileUploadRepository.getOccupantSignSaveStatus(ActualFileData: event.file,
            work_id: event.work_id , type: event.type );

        emit(OccupantSignFilesSuccess(upload_status));

      }catch(e){
        emit(OccupantSignFilesFailure(e.toString()));
      }

    });

  }





}