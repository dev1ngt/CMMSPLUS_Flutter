import 'package:bloc/bloc.dart';
import 'package:cmms/src/features/request/view/bloc/request_view_event.dart';
import 'package:cmms/src/features/request/view/bloc/request_view_state.dart';

import '../../../../api/api_service.dart';

class RequestViewBloc extends Bloc<RequestViewEvent, RequestViewState> {
  final ApiService requestRepo;

  RequestViewBloc(this.requestRepo) : super(RequestViewInitialState()) {
    on<RequestViewInitEvent>((event, emit) {});
    on<RequestViewLoadEvent>((event, emit) async {
      emit(RequestViewInitialState());
      print("You emitted first state test");
      try {
        final requestData = await requestRepo.getRequestViewByID(
            requestID: event.requestID);
        emit(RequestViewLoadedState(requestData));
      } catch (e) {
        emit(RequestViewErrorState(e.toString()));
      }
    });
    on<RequestViewSubmitEvent>((event, emit) async {
      emit(RequestViewSubmitInitialState());
      print("You emitted first state test");
      try {
        final requestData = await requestRepo.getRequestViewSubmit(
            requestID: event.requestID,
            userID: event.userID,
            assigneeID: event.assigneeID,
            statusID: event.statusID,
            remarks: event.comments,
            additionalSpace: event.additionalSpace,
            estimatedAmt: event.estimatedAmt,
            uploadFiles: event.uploadedFiles,
            assetID: event.assetID);
        emit(RequestViewSubmitLoadedState(requestData));
      } catch (e) {
        emit(RequestViewSubmitErrorState(e.toString()));
      }
    });

    on<uploadFileInProgressEvent>((event, emit) async {
      emit(UploadFilesInitial());
      try {
        final upload_status = await requestRepo.getFileUploadStatus(
            ActualFileData: event.file, FileName: event.FileName);

        emit(UploadFilesSuccess(upload_status));
      } catch (e) {
        emit(UploadFilesFailure(e.toString()));
      }
    });

    on<DeleteUploadedFileEvent>((event, emit) async {
      emit(DeleteFileInProgress());
      try {
        final response = await requestRepo.deleteAttachment(id: event.id, requestId: event.requestId);

        emit(DeleteFileSuccess(response));
      } catch (e) {
        emit(DeleteFileFailure(e.toString()));
      }
    });
  }
}
