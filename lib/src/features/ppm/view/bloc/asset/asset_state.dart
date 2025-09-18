
import 'package:flutter/cupertino.dart';

import '../../model/asset/AssetResponse.dart';


@immutable
sealed class MultipleAssetsState {
}

class MultipleAssetsInitialState extends MultipleAssetsState {
}

class MultipleAssetsInProgressState extends MultipleAssetsState {
}

class MultipleAssetsLoadedState extends MultipleAssetsState {
  MultipleAssetsLoadedState(this.asset_response);
  final AssetsResponse asset_response;

}

class MultipleAssetsErrorState extends MultipleAssetsState {
  MultipleAssetsErrorState(this.error);
  final String error;

}