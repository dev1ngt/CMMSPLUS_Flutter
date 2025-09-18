
import 'dart:io';

import 'package:cmms/src/api/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'postworkevent.dart';
import 'postworkstate.dart';



class PostWorkBloc extends Bloc<PostWorkEvent, PostWorkState> {

  final ApiService fileUploadRepository;
  PostWorkBloc(this.fileUploadRepository) : super(PostWorkInitial()){
    on<PostWorkLoadEvent>((event, emit) {});
    on<PostWorkInProgressEvent> ((event , emit) async{
      emit(PostWorkInitial());
      try{
        final upload_status = await
        fileUploadRepository.getPostImageDelete(taskid: event.taskid);

        emit(PostWorkSuccess(upload_status));

      }catch(e){
        emit(PostWorkFailure(e.toString()));
      }

    });

  }

}