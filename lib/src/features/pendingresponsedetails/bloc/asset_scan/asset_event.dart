


import 'package:cmms/src/features/pendingresponse/model/asset_model.dart';

sealed class AssetScanEvent {
}


class AssetScanEventInit extends AssetScanEvent{
}

class FetchAssetScanEvent extends AssetScanEvent {


  FetchAssetScanEvent(this.assetInput);
  AssetInput assetInput = AssetInput();


}