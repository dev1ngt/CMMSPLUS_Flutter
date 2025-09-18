



import 'package:bloc/bloc.dart';
import 'package:cmms/src/features/faultreport/thirdremarks/bloc/remarks_event.dart';
import 'package:cmms/src/features/faultreport/thirdremarks/bloc/remarks_state.dart';

import '../../../../api/api_service.dart';

class RemarksBloc extends Bloc<RemarksEvent, RemarksState> {
  final ApiService repository;

  RemarksBloc(this.repository) : super(RemarksInitial()) {
    on<RemarkLoadEvent>((event, emit) {});
    on<NextClickEvent>((event, emit) async {

       emit(BlocButtonClickedState());

    });
  }
}