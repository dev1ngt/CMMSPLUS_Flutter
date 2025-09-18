


import 'package:bloc/bloc.dart';
import 'package:cmms/src/features/ppm/completed/bloc/ppm_det_completed_event.dart';
import 'package:cmms/src/features/ppm/completed/bloc/ppm_det_completed_state.dart';

import '../../../../api/api_service.dart';

class PPMCompletedBloc extends Bloc<PPMCompletedEvent, PPMCompletedState> {

  final ApiService fileUploadRepository;
  PPMCompletedBloc(this.fileUploadRepository) : super(PPMCompletedInit()) {
    on<PPMCompletedInitEvent>((event, emit) {});

    on<PPMCompletedStartEvent>((event, emit)  async{

      emit(PPMCompletedInProgress());
      try{
        final upload_status = await
        fileUploadRepository.getViewSubScheduleAPI(sub_schedule_id: event.sub_schedule_id);

        emit(PPMCompletedSuccess(upload_status));

      }catch(e){
        emit(PPMCompletedFailure(e.toString()));
      }

    });

  }
}