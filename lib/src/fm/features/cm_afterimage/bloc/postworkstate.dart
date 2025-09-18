
import 'package:flutter/cupertino.dart';

import '../model/image_delete/preimage_deleteresponse_model.dart';


@immutable
sealed class PostWorkState {}

class PostWorkInitial extends PostWorkState {}

class PostWorkInProgress extends PostWorkState {}

class PostWorkSuccess extends PostWorkState {
  PostWorkSuccess(this.fileuploadresponse);
  final RemovalPostResponse fileuploadresponse;
}

class PostWorkFailure extends PostWorkState {
  final String error;
  PostWorkFailure(this.error);
}