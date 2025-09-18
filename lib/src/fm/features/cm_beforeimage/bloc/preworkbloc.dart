
import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'preworkevent.dart';
import 'preworkstate.dart';



class PreWorkBloc extends Bloc<PreWorkEvent, PreWorkState> {

  final ApiService fileUploadRepository;
  PreWorkBloc(this.fileUploadRepository) : super(PreWorkInitial()){
    on<PreWorkLoadEvent>((event, emit) {});
    on<PreWorkInProgressEvent> ((event , emit) async{
      emit(PreWorkInitial());
      try{
        final upload_status = await
        fileUploadRepository.getImageDelete(taskid: event.taskid);

        emit(PreWorkSuccess(upload_status));

      }catch(e){
        emit(PreWorkFailure(e.toString()));
      }

    });

  }

}