class AdhocDetailsViewModel {
  final bool isError;
  final String message;
  final AdhocData data;

  AdhocDetailsViewModel({
    required this.isError,
    required this.message,
    required this.data,
  });

  factory AdhocDetailsViewModel.fromJson(Map<String, dynamic> json) {
    return AdhocDetailsViewModel(
      isError: json['IsError'],
      message: json['Message'],
      data: AdhocData.fromJson(json['data']),
    );
  }
}

class AdhocData {
  final String inspectionId;
  final String adhocInspectionId;
  final String regionName;
  final String propertyName;
  final String levelName;
  final String inspectionClass;
  final String inspector;
  final String occupant;
  final String location;
  final String assetName;
  final String inspectionDate;
  final String webUrl;

  AdhocData({
    required this.inspectionId,
    required this.adhocInspectionId,
    required this.regionName,
    required this.propertyName,
    required this.levelName,
    required this.inspectionClass,
    required this.inspector,
    required this.occupant,
    required this.location,
    required this.assetName,
    required this.inspectionDate,
    required this.webUrl,
  });

  factory AdhocData.fromJson(Map<String, dynamic> json) {
    return AdhocData(
      inspectionId: json['inspection_id'],
      adhocInspectionId: json['adhoc_inspection_id'],
      regionName: json['regionName'],
      propertyName: json['property_name'],
      levelName: json['level_name'],
      inspectionClass: json['inspection_class'],
      inspector: json['inspector'],
      occupant: json['occupant'],
      location: json['location'],
      assetName: json['asset_name'],
      inspectionDate: json['inspection_date'],
      webUrl: json['web_url'],
    );
  }
}
