




import 'package:bloc/bloc.dart';
import 'package:cmms/src/features/pendingresponse/model/asset_model.dart';

import '../../../../api/api_service.dart';
import 'asset_event.dart';
import 'asset_state.dart';

class AssetScanBloc extends Bloc<AssetScanEvent, AssetScanState> {
  final ApiService pendingRepository;

  AssetScanBloc(this.pendingRepository) : super(AssetScanInitialState()) {
    on<AssetScanEventInit> ((event,emit) {});
    on<FetchAssetScanEvent>((event, emit) async {
      emit(AssetScanInprogressState());
      try {
        final response = await pendingRepository.postAssetScanReponse(assetInput: event.assetInput);
        emit(AssetScanLoadedState(response));
      } catch (e) {
        emit(AssetScanErrorState(e.toString()));
      }
    }

    );

  }}
