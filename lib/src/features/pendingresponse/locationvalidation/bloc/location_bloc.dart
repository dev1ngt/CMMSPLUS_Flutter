



import 'package:bloc/bloc.dart';

import '../../../../api/api_service.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationValidationBloc extends Bloc<LocationValidationEvent, LocationValidationState> {
  final ApiService pendingRepository;

  LocationValidationBloc(this.pendingRepository) : super(LocationInitialState()) {
    on<LocationEventInit> ((event,emit) {});
    on<FetchLocationEvent>((event, emit) async {

     emit(LocationInitialState());

      try {
        final response = await pendingRepository.getLocationValidate(
          latitude: event.latitude,
          longitude: event.longitude,
          propertyID: event.propertyID,
        );

        if (response.status) {
          emit(LocationLoadedState(response));
        } else {
          emit(LocationLoadedState(response));
        }
      } catch (e) {
        emit(LocationErrorState(e.toString()));
      }
    }

    );

  }}

