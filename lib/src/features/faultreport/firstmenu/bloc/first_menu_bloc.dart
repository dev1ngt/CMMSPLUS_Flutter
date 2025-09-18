



import 'package:bloc/bloc.dart';

import '../../../../api/api_service.dart';
import 'first_menu_event.dart';
import 'first_menu_state.dart';

class FRFirstMenuBloc extends Bloc<FRFirstMenuEvent, FRFirstMenuState> {

  final ApiService pendingRepository;

  FRFirstMenuBloc(this.pendingRepository) : super(FRFirstMenuInitial()) {
    on<FRFirstMenuFetchEvent>((event, emit) async {
      emit(FRFirstMenuInitial());
      try {
        final findtype = await pendingRepository.getFindType(event.requestId);
        emit(FRFirstMenuLoaded(findtype));
      }catch(e){
        emit(FRFirstMenuError(e.toString()));
      }

    });
  }
}