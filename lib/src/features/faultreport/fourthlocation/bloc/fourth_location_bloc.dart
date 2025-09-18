


import 'package:bloc/bloc.dart';

import '../../../../api/api_service.dart';
import 'fourth_location_event.dart';
import 'fourth_location_state.dart';

class FRFourthLocationBloc extends Bloc<FRFourthLocationEvent, FRFourthLocationState> {

  final ApiService pendingRepository;

  FRFourthLocationBloc(this.pendingRepository) : super(FRFourthLocationInitial()) {
    on<FRFourthLocationFetchEvent>((event, emit) async {
      emit(FRFourthLocationInitial());
      try {
        final findtype = await pendingRepository.getLocationList(requestId: event.requestId);
        emit(FRFourthLocationLoaded(findtype));
      }catch(e){
        emit(FRFourthLocationError(e.toString()));
      }

    });



  }
}