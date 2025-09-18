


import 'package:bloc/bloc.dart';

import '../../../api/api_service.dart';
import 'forgotpass_event.dart';
import 'forgotpass_state.dart';

class ForgotPassBloc extends Bloc<ForgotPassEvent, ForgotPassState> {
  final ApiService pendingRepository;

  ForgotPassBloc(this.pendingRepository) : super(ForgotPassInitialState()) {
    on<ForgotPassFetchEvent> ((event,emit) {});
    on<SubmitClickEvent>((event, emit) async {

      emit(ForgotPassInitialState());

      try {
        final response = await pendingRepository.getResetPasswordAPI(current_password: event.current_password, confirm_password: event.confirm_password, new_password: event.new_password);

        if (response.isError) {
          emit(ForgotPassLoadedState(response));
        } else {
          emit(ForgotPassLoadedState(response));
        }
      } catch (e) {
        emit(ForgotPassErrorState(e.toString()));
      }
    }

    );

  }}
