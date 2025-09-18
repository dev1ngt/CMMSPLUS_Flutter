


// Define your Bloc class
import 'package:bloc/bloc.dart';

import '../../../../../api/api_service.dart';
import 'adhoc_add_new_view_event.dart';
import 'adhoc_add_new_view_state.dart';


class AdhocAddNewViewBloc extends Bloc<AdhocAddNewViewEvent, AdhocAddNewViewState> {
//final DashboardRepository repository;
  final ApiService repository;

  AdhocAddNewViewBloc(this.repository) : super(AdhocAddNewViewInitState()) {


    on<AdhocAddNewViewItemEvent>((event, emit) async {
      emit(AdhocAddNewViewLoadingState());
      print("You emitted first state test");
      try {
        final pendinglist = await repository.getAdhocAddnewView();
        emit(AdhocAddNewViewLoadedState(pendinglist));
      } catch (e) {
        emit(AdhocAddNewViewErrorState(e.toString()));
      }
    });


    /* Call webview */

    on<AdhocAddNewWebViewEvent>((event, emit) async {
      emit(AdhocAddNewWebViewLoadingState());
      print("You emitted first state test");
      try {
        final pendinglist = await repository.getAdhocAddWebView(inspectionClass: event.inspectionClass, token: event.token);
        emit(AdhocAddNewWebViewLoadedState(pendinglist));
      } catch (e) {
        emit(AdhocAddNewWebViewErrorState(e.toString()));
      }
    });

    /* Call Space / Floor */

    on<AdhocAddNewSpaceFloorFilterEvent>((event, emit) async {
      emit(AdhocAddNewSpaceFloorLoadingState());
      print("You emitted first state test");
      try {
        final pendinglist = await repository.getAdhocSpaceFloorFilter( property_id: event.propertyID);
        emit(AdhocAddNewSpaceFloorLoadedState(pendinglist));
      } catch (e) {
        emit(AdhocAddNewSpaceFloorErrorState(e.toString()));
      }
    });

    /* Call Asset */

    on<AdhocAddNewAssetFilterEvent>((event, emit) async {
      emit(AdhocAddNewAssetLoadingState());
      print("You emitted first state test");
      try {
        final pendinglist = await repository.getAdhocAssetFilter( property_id: event.propertyID);
        emit(AdhocAddNewAssetLoadedState(pendinglist));
      } catch (e) {
        emit(AdhocAddNewAssetErrorState(e.toString()));
      }
    });


    /* Submit Adhoc Inspection */
    on<AdhocAddNewSubmitEvent>((event, emit) async {
      emit(AdhocAddNewSubmitLoadingState());
      print("You emitted first state test");
      try {
        final pendinglist = await repository.getAdhocNewInspectionSubmit(inspectionClass: event.inspectionClass , token: event.token, property_id: event.property_id,
            space_floor_id: event.space_floor_id, asset_id: event.asset_id, occupant: event.occupant, location: event.location );
        emit(AdhocAddNewSubmitLoadedState(pendinglist));
      } catch (e) {
        emit(AdhocAddNewSubmitErrorState(e.toString()));
      }
    });


  }


}