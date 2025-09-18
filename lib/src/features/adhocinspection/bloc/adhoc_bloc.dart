import 'package:cmms/src/features/adhocinspection/bloc/adhoc_event.dart';
import 'package:cmms/src/features/adhocinspection/bloc/adhoc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../api/api_service.dart';

class AdhocListBloc extends Bloc<AdhocListEvent, AdhocListMyState> {
  final ApiService pendingRepository;

  AdhocListBloc(this.pendingRepository) : super(AdhocListInitial()) {
    on<FetchAdhocListEvent>((event, emit) async {
      emit(AdhocListInitial());

      try {
        final adhoclist =
            await pendingRepository.getAdhocList(type: event.status_type, page: event.page_no);
        emit(AdhocListLoaded(adhoclist));
      } catch (e) {
        emit(AdhocListError(e.toString()));
      }
    });
  }
}
