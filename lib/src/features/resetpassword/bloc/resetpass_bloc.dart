import 'package:bloc/bloc.dart';
import 'package:cmms/src/features/resetpassword/bloc/resetpass_event.dart';
import 'package:cmms/src/features/resetpassword/bloc/resetpass_state.dart';
import '../../../api/api_service.dart';


class ResetPassBloc extends Bloc<ResetPassEvent, ResetPassState> {
  final ApiService pendingRepository;

  ResetPassBloc(this.pendingRepository) : super(ResetPassInitialState()) {
    on<ResetPassFetchEvent> ((event,emit) {});
    on<SubmitClickEvent>((event, emit) async {

      emit(ResetPassInitialState());

      try {
        final response = await pendingRepository.getResetPasswordAPIDashboard(current_password: event.current_password, confirm_password: event.confirm_password, new_password: event.new_password);

        if (response.isError) {
          emit(ResetPassLoadedState(response));
        } else {
          emit(ResetPassLoadedState(response));
        }
      } catch (e) {
        emit(ResetPassErrorState(e.toString()));
      }
    }

    );

  }}
