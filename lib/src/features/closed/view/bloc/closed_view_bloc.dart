import 'package:bloc/bloc.dart';
import '../../../../api/api_service.dart';
import 'closed_view_event.dart';
import 'closed_view_state.dart';

class ClosedViewBloc extends Bloc<ClosedViewEvent, ClosedViewState> {
  final ApiService requestRepo;

  ClosedViewBloc(this.requestRepo) : super(ClosedViewInitialState()) {
    on<ClosedViewInitEvent>((event, emit) {});
    on<ClosedViewLoadEvent>((event, emit) async {
      emit(ClosedViewInitialState());
      print("You emitted first state test");
      try {
        final requestData = await requestRepo.getClosedViewByID(
            requestID: event.requestID);
        emit(ClosedViewLoadedState(requestData));
      } catch (e) {
        emit(ClosedViewErrorState(e.toString()));
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
  }
}
