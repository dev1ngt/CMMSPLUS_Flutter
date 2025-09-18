import 'dart:io';

import '../../model/ppm_submit_request_model.dart';

sealed class PPMSubmitEvent {}


class PPMSubmitInitEvent extends PPMSubmitEvent{}


class PPMSubmitInProgressEvent extends PPMSubmitEvent{
  PPMSubmitRequestModelOne submitRequestModel;
  PPMSubmitInProgressEvent(this.submitRequestModel );
}