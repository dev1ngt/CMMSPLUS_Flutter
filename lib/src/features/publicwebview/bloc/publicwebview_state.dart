
import 'package:flutter/cupertino.dart';

import '../model/asset_response_model.dart';



@immutable
sealed class PublicWebviewState {}


class PublicWebviewInitial extends PublicWebviewState {}


class PublicWebviewScanLoad extends PublicWebviewState {}

class PublicWebviewSuccess extends PublicWebviewState {

  PublicWebviewSuccess(this.assetResponseModel);
 final AssetResponseModel assetResponseModel;

}

class PublicWebviewFailure extends PublicWebviewState {
  PublicWebviewFailure(this.error);
  final String error;
}