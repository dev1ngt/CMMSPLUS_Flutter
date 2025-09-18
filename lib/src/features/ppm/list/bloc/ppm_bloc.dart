import 'dart:async';

import 'package:cmms/src/features/ppm/list/bloc/ppm_event.dart';
import 'package:cmms/src/features/ppm/list/bloc/ppm_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../api/api_service.dart';





class PPMListBloc extends Bloc<PPMListEvent, PPMListMyState> {

  final ApiService pendingRepository;

  PPMListBloc(this.pendingRepository) : super(PPMListInitial()) {
    on<FetchPPMListEvent>((event, emit) async {
      emit(PPMListInitial());

      try {
        final ppmlist = await pendingRepository.getPPMList(type: event.status_type);
        emit(PPMListLoaded(ppmlist));
      }catch(e){
        emit(PPMListError(e.toString()));
      }

    });
  }
}
