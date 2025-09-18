
import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ppm_postworkevent.dart';
import 'ppm_postworkstate.dart';



class PPMPostWorkBloc extends Bloc<PPMPostWorkEvent, PPMPostWorkState> {

  final ApiService fileUploadRepository;
  PPMPostWorkBloc(this.fileUploadRepository) : super(PPMPostWorkInitial()){
    on<PPMPostWorkLoadEvent>((event, emit) {});
    on<PPMPostWorkInProgressEvent> ((event , emit) async{
      emit(PPMPostWorkInitial());
      try{
        final upload_status = await
        fileUploadRepository.getPPMImageDelete(taskid: event.taskid);

        emit(PPMPostWorkSuccess(upload_status));

      }catch(e){
        emit(PPMPostWorkFailure(e.toString()));
      }

    });

  }

}