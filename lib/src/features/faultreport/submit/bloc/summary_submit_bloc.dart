import 'package:bloc/bloc.dart';
import 'package:cmms/src/features/faultreport/submit/bloc/summary_submit_event.dart';
import 'package:cmms/src/features/faultreport/submit/bloc/summary_submit_state.dart';

import '../../../../api/api_service.dart';

class FRSubmitBloc extends Bloc<FRSubmitEvent, FRSubmitState> {
  final ApiService pendingRepository;

  FRSubmitBloc(this.pendingRepository) : super(FRSubmitInitial()) {
    on<FRSubmitFetchEvent>((event, emit) {});
    on<FRSubmitClick>((event, emit) async {
      emit(FRSubmitInProgress());
      try {
        final findtype = await pendingRepository.doCallSubmitFaultReport(
            faultReportSaveModel: event.submitResponse);
        emit(FRSubmitLoaded(findtype));
      } catch (e) {
        emit(FRSubmitError(e.toString()));
      }
    });

    on<FRSubmitClick1>((event, emit) async {
      emit(FRSubmitInProgress());
      try {
        final findtype = await pendingRepository.doCallSubmitFaultReport1(
            faultReportoldSaveModel: event.submitResponse);
        emit(FRSubmitLoaded(findtype));
      } catch (e) {
        emit(FRSubmitError(e.toString()));
      }
    });

    on<uploadFileInProgressEvent>((event, emit) async {
      emit(UploadFilesInitial());
      try {
        final upload_status = await pendingRepository.getFileUploadStatus(
            ActualFileData: event.file, FileName: event.FileName);

        emit(UploadFilesSuccess(upload_status));
      } catch (e) {
        emit(UploadFilesFailure(e.toString()));
      }
    });

    /* Priority */

    on<FRPriorityEvent>((event, emit) async {
      emit(FRPriorityInProgress());
      try {
        final priority = await pendingRepository.doCallFaultReportPriority(
            priorityRequestModel: event.priorityRequestModel, requestId: event.requestId);
        emit(FRPrioritySuccess(priority));
      } catch (e) {
        emit(FRPriorityFailure(e.toString()));
      }
    });
  }
}
