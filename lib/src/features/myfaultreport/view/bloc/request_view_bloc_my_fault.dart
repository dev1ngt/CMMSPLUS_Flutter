import 'package:bloc/bloc.dart';
import 'package:cmms/src/features/myfaultreport/view/bloc/request_view_event_my_fault.dart';
import 'package:cmms/src/features/myfaultreport/view/bloc/request_view_state_my_fault.dart';
import '../../../../api/api_service.dart';

class MyFaultRequestViewBloc
    extends Bloc<MyFaultRequestViewEvent, MyFaultRequestViewState> {
  final ApiService requestRepo;

  MyFaultRequestViewBloc(this.requestRepo)
      : super(MyFaultRequestViewInitialState()) {
    on<MyFaultRequestViewInitEvent>((event, emit) {});

    on<MyFaultRequestViewLoadEvent>((event, emit) async {
      emit(MyFaultRequestViewInitialState());
      print("You emitted first state test");
      try {
        final requestData =
            await requestRepo.getRequestViewByID(requestID: event.requestID);
        emit(MyFaultRequestViewLoadedState(requestData));
      } catch (e) {
        emit(MyFaultRequestViewErrorState(e.toString()));
      }
    });

    on<MyFaultRequestViewSubmitEvent>((event, emit) async {
      emit(MyFaultRequestViewSubmitInitialState());
      print("You emitted first state test");
      try {
        final requestData = await requestRepo.getRequestViewSubmit(
            requestID: event.requestID,
            userID: event.userID,
            assigneeID: event.assigneeID,
            statusID: event.statusID,
            remarks: event.comments,
            additionalSpace: event.additionalSpace,
            uploadFiles: event.uploadedFiles,
            assetID: event.assetID);
        emit(MyFaultRequestViewSubmitLoadedState(requestData));
      } catch (e) {
        emit(MyFaultRequestViewSubmitErrorState(e.toString()));
      }
    });

    on<MyFaultUploadFileInProgressEvent>((event, emit) async {
      emit(MyFaultUploadFilesInitial());
      try {
        final upload_status = await requestRepo.getFileUploadStatus(
            ActualFileData: event.file, FileName: event.FileName);

        emit(MyFaultUploadFilesSuccess(upload_status));
      } catch (e) {
        emit(MyFaultUploadFilesFailure(e.toString()));
      }
    });

    on<MyFaultDeleteUploadedFileEvent>((event, emit) async {
      emit(MyFaultDeleteFileInProgress());
      try {
        final response = await requestRepo.deleteAttachment(
            id: event.id, requestId: event.requestId);

        emit(MyFaultDeleteFileSuccess(response));
      } catch (e) {
        emit(DeleteFileFailure(e.toString()));
      }
    });
  }
}
