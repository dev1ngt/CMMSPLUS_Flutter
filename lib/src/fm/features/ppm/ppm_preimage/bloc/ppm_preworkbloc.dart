
import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ppm_preworkevent.dart';
import 'ppm_preworkstate.dart';



class PPMPreWorkBloc extends Bloc<PPMPreWorkEvent, PPMPreWorkState> {

  final ApiService fileUploadRepository;
  PPMPreWorkBloc(this.fileUploadRepository) : super(PPMPreWorkInitial()){
    on<PPMPreWorkLoadEvent>((event, emit) {});
    on<PPMPreWorkInProgressEvent> ((event , emit) async{
      emit(PPMPreWorkInitial());
      try{
        final upload_status = await
        fileUploadRepository.getPPMImageDelete(taskid: event.taskid);

        emit(PPMPreWorkSuccess(upload_status));

      }catch(e){
        emit(PPMPreWorkFailure(e.toString()));
      }

    });

  }

}