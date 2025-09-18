



import 'package:bloc/bloc.dart';
import 'package:cmms/src/features/faultreport/secondpriority/bloc/second_priority_event.dart';
import 'package:cmms/src/features/faultreport/secondpriority/bloc/second_priority_state.dart';
import 'package:cmms/src/features/faultreport/submit/model/fault_report_save_model.dart';

import '../../../../api/api_service.dart';

class FRSecondPriorityBloc extends Bloc<FRSecondPriorityEvent, FRSecondPriorityState> {

  final ApiService pendingRepository;

  FRSecondPriorityBloc(this.pendingRepository) : super(FRSecondPriorityInitial()) {
    on<FRSecondPriorityFetchEvent>((event, emit) async {
      emit(FRSecondPriorityInitial());
      try {
        final findtype = await pendingRepository.getPriorityType();
        emit(FRSecondPriorityLoaded(findtype));
      }catch(e){
        emit(FRSecondPriorityError(e.toString()));
      }

    });


   on<FRSecondPrioritySaveData>((event, emit)   async {

     emit(FRSecondPrioritySaveDataLoaded(FaultReportSaveModel()));

   });

  }
}