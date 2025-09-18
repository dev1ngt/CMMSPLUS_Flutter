import 'package:bloc/bloc.dart';
import 'package:cmms/src/features/checkin_out/bloc/report/report_event.dart';
import 'package:cmms/src/features/checkin_out/bloc/report/report_state.dart';

import '../../../../api/api_service.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ApiService pendingRepository;

  ReportBloc(this.pendingRepository) : super(ReportInitial()) {
    on<FetchReportDetails>((event, emit) async {
      emit(ReportInitial());

      try {
        final reportList =
        await pendingRepository.getReportList(year: event.year, month: event.month, pageNo: event.pageNo);
        emit(ReportLoaded(reportList));
      } catch (e) {
        emit(ReportError(e.toString()));
      }
    });
  }

}