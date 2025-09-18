



import '../../model/asset/AssetResponse.dart';

sealed class MultipleAssetsEvent {
}

class MultipleAssetsEventInit extends MultipleAssetsEvent{
}

class MultipleAssetsFetchEvent extends MultipleAssetsEvent {

  MultipleAssetsFetchEvent(this.assetInput);
  MultiAssetInput assetInput = MultiAssetInput();


}