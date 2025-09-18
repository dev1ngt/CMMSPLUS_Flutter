import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cmms/src/features/pendingresponsedetails/model/SignatureUploadResponseModel.dart';
import 'package:cmms/src/features/pendingresponsedetails/model/TechnicianInitiateRequestModel.dart';
import 'package:meta/meta.dart';

import '../../../../api/api_service.dart';
import 'details_part2_event.dart';
import 'details_part2_state.dart';




class DetailsPart2Bloc extends Bloc<DetailsPart2Event, DetailsPart2State> {

  final ApiService fileUploadRepository;
  DetailsPart2Bloc(this.fileUploadRepository) : super(DetailsPart2Initial()) {
    on<SignFileInitEvent>((event, emit) {});
    on<SignFileInProgressEvent>((event, emit) async {
      // TODO: implement event handler
      emit(DetailsPart2InProgress());
      try{
        final upload_status = await
        fileUploadRepository.getSignUploadStatus(ActualFileData: event.file,
            FileName: event.FileName);

        emit(SignUploadSuccess(upload_status));

      }catch(e){
        emit(SignUploadFailure(e.toString()));
      }

    });

   on<SubmitClickEvent>((event, emit)  async{

     emit(SubmitUploadInit());
     try{
       final upload_status = await
       fileUploadRepository.postSubmitPendingReponse(technicianInitiateRequestModel: event.technicianInitiateRequestModel);

       emit(SubmitUploadSuccess(upload_status));

     }catch(e){
       emit(SubmitUploadFailure(e.toString()));
     }


   });

  }
}
