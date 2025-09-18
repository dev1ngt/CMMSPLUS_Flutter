// bloc.dart
import 'package:cmms/src/features/pendingresponse/bloc/pending_event.dart';
import 'package:cmms/src/features/pendingresponse/bloc/pending_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../api/api_service.dart';





class InProgressBloc extends Bloc<InProgressEvent, InProgressState> {
  final ApiService pendingRepository;

  InProgressBloc(this.pendingRepository) : super(InProgressInitialState()) {
    on<FetchInProgressEvent>((event, emit) async {
      emit(InProgressInitialState());

      try {
        final pendinglist = await pendingRepository.getPendingList(page: event.pageNo, propertyid: event.propertyID);
        emit(InProgressLoadedState(pendinglist));
      } catch (e) {
        emit(InProgressErrorState(e.toString()));
      }
    });

}}