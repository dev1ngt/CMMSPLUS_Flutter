



import 'package:bloc/bloc.dart';

import '../../../../api/api_service.dart';
import 'fifth_room_event.dart';
import 'fifth_room_state.dart';

class FRFifthRoomBloc extends Bloc<FRFifthRoomEvent, FRFifthRoomState> {

  final ApiService pendingRepository;

  FRFifthRoomBloc(this.pendingRepository) : super(FRFifthRoomInitial()) {
    on<FRFifthRoomFetchEvent>((event, emit) async {
      emit(FRFifthRoomInitial());
      try {
        final findtype = await pendingRepository.getRoomList(roomRequestModel: event.roomRequestModel, requestId: event.requestId);
        emit(FRFifthRoomLoaded(findtype));
      }catch(e){
        emit(FRFifthRoomError(e.toString()));
      }

    });



  }
}