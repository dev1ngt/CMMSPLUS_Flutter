import 'package:cmms/src/features/checkin_out/model/report_response_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  ReportLoaded(this.reportDetails);
  final ReportResponseModel reportDetails;
}

class ReportError extends ReportState {
  final String message;

  ReportError(this.message);
}
