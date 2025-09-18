


import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/api_service.dart';
import 'InProgressViewEvent.dart';
import 'InProgressViewState.dart';

class InProgressViewBloc extends Bloc<InProgressViewEvent, InProgressViewState> {

  final ApiService UploadRepository;
  InProgressViewBloc(this.UploadRepository) : super(InProgressViewInitial()) {
    on<InProgressViewsInitEvent>((event, emit) {});
    on<InProgressViewsEvent>((event, emit) async{
      emit(InProgressViewInfo());

      try{
        final upload_status = await UploadRepository.getInProgressDetails();
        emit(InProgressViewSuccess(upload_status));
      }catch(e){
        emit(InProgressViewFailure(e.toString()));
        print(e);
      }

    });

    on<InProgressSubmitEvent>((event, emit) async{
      emit(InProgressSubmitLoad());

      try{
        final upload_status = await UploadRepository.postInProgressSubmit(inprogressSubmitRequestModel: event.inprogressSubmitRequestModel);
        emit(InProgressSubmitSuccess(upload_status));
      }catch(e){
        emit(InProgressSubmitFailure(e.toString()));
        print(e);
      }

    });

  }
}