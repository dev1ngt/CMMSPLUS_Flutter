
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../api/api_service.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  //final DashboardRepository repository;
  final ApiService repository;

  DashboardBloc(this.repository) : super(DashboardLoadingState()) {
    on<LoadDashboardEvent>((event, emit) async {
      emit(DashboardLoadingState());
      try {
        final pendinglist = await repository.getDashboard();
        emit(DashboardLoadedState(pendinglist));
      } catch (e) {
        emit(DashboardErrorState(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      final currentState = state;

      if (currentState is DashboardLoadedState) {
        // Step 1: Show logout spinner
        emit(currentState.copyWith(isLoggingOut: true));

        try {
          final response = await repository.logout();

          // Step 2: Handle success (UI can listen to this state if needed)
          emit(currentState.copyWith(isLoggingOut: false));
          emit(LogoutSuccessState(response));

          // Optional: emit back the dashboard state again
          emit(currentState);
        } catch (e) {
          emit(currentState.copyWith(isLoggingOut: false));
          emit(LogoutErrorState(e.toString()));
          emit(currentState); // restore dashboard view
        }
      }
    });


  }

}