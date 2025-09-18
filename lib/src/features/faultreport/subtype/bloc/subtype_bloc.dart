



import 'package:bloc/bloc.dart';

import '../../../../api/api_service.dart';
import 'subtype_event.dart';
import 'subtype_state.dart';

class SubtypeBloc extends Bloc<SubtypeEvent, SubtypeState> {

  final ApiService pendingRepository;

  SubtypeBloc(this.pendingRepository) : super(SubtypeInitial()) {
    on<SubtypeFetchEvent>((event, emit) async {
      emit(SubtypeInitial());
      try {
        final findtype = await pendingRepository.getSubTypeList(subtypeRequest: event.subtypeRequestModel, requestId: event.requestId);
        emit(SubtypeLoaded(findtype));
      }catch(e){
        emit(SubtypeError(e.toString()));
      }

    });
  }
}