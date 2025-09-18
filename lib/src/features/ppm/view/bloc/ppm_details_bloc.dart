import 'package:bloc/bloc.dart';
import 'package:cmms/src/features/ppm/list/model/ppm_list_response_model.dart';
import 'dart:io';

import 'package:cmms/src/features/ppm/view/bloc/ppm_details_event.dart';
import 'package:cmms/src/features/ppm/view/bloc/ppm_details_state.dart';

import '../../../../api/api_service.dart';
import '../model/ppm_details_response_model.dart';
import '../model/ppm_details_submit_request.dart';

class PPMDetailsBloc extends Bloc<PPMDetailsEvent, PPMDetailsStateI> {
  final ApiService fileUploadRepository;

  PPMDetailsBloc(this.fileUploadRepository)
      : super(PPMDetailsInitialState()) {
    /// Init event (page load)
    on<PPMDetailsInitEvent>((event, emit) {
      emit(PPMDetailsInitialState());
    });

    on<PPMDetailsLoadEvent>((event, emit) async {
      emit(PPMDetailsLoadingState());
      try {
        final ppmDetails = await fileUploadRepository.getPPMDetails(subScheduleId: event.scheduleID);
        emit(PPMDetailsLoadedState(ppmDetails as PPMDetailsResponseModel));
      } catch (e) {
        emit(PPMDetailsErrorState(e.toString()));
      }
    });

    on<PPMDetailsSubmitEvent>((event, emit) async {
      emit(PPMDetailsSubmitUploadInProgress());
      try {
        final response = await fileUploadRepository.postSubmitPPMDetails(
          ppmSubmitRequestModel: event.ppmSubmitRequestModel,
        );
        emit(PPMDetailsSubmitUploadSuccess(response));
      } catch (e) {
        emit(PPMDetailsSubmitUploadFailure(e.toString()));
      }
    });


    /// File upload in progress
    on<PPMUploadFileInProgressEvent>((event, emit) async {
      emit(PPMUploadFilesInitial());
      try {
        final uploadStatus = await fileUploadRepository.getFileUploadStatus(
          ActualFileData: event.file,
          FileName: event.fileName,
        );
        emit(PPMUploadFilesSuccess(uploadStatus));
      } catch (e) {
        emit(PPMUploadFilesFailure(e.toString()));
      }
    });

    /// Delete uploaded file
    on<PPMDeleteUploadedFileEvent>((event, emit) async {
      emit(PPMDeleteFileInProgress());
      try {
        final response = await fileUploadRepository.deleteAttachment(
          id: event.id,
          requestId: event.ppmScheduleId,
        );
        emit(PPMDeleteFileSuccess(response));
      } catch (e) {
        emit(PPMDeleteFileFailure(e.toString()));
      }
    });
  }
}

