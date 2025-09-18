



import 'package:cmms/src/features/pendingresponse/model/asset_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class AssetScanState {
}

class AssetScanInitialState extends AssetScanState {
}

class AssetScanInprogressState extends AssetScanState {
}

class AssetScanLoadedState extends AssetScanState {
  AssetScanLoadedState(this.asset_response);
  final AssetResponse asset_response;

}

class AssetScanErrorState extends AssetScanState {
  AssetScanErrorState(this.error);
  final String error;

}