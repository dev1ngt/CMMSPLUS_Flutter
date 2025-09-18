


import 'package:bloc/bloc.dart';

import '../../../../../api/api_service.dart';
import 'asset_event.dart';
import 'asset_state.dart';

class MultipleAssetsBloc extends Bloc<MultipleAssetsEvent, MultipleAssetsState> {
  final ApiService pendingRepository;

  MultipleAssetsBloc(this.pendingRepository) : super(MultipleAssetsInitialState()) {
    on<MultipleAssetsEventInit> ((event,emit) {});
    on<MultipleAssetsFetchEvent>((event, emit) async {
      emit(MultipleAssetsInProgressState());
      try {
        final response = await pendingRepository.postMultiAssetReponse(assetInput: event.assetInput);
        emit(MultipleAssetsLoadedState(response));
      } catch (e) {
        emit(MultipleAssetsErrorState(e.toString()));
      }
    }

    );

  }}
