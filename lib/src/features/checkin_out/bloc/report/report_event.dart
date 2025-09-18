import 'package:flutter/cupertino.dart';

@immutable
abstract class ReportEvent {}

class FetchReportDetails extends ReportEvent {
  late final String month;
  late final String year;
  late final String pageNo;

  FetchReportDetails({required this.month, required this.year, required this.pageNo});
}
