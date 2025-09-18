class RootCauseResponse {
  final String status;
  final List<RootCauseDetail> data;

  RootCauseResponse({
    required this.status,
    required this.data,
  });

  factory RootCauseResponse.fromJson(Map<String, dynamic> json) {
    var rootCause = json['data'] as List;
    List<RootCauseDetail> details = rootCause.map((customerJson) => RootCauseDetail.fromJson(customerJson)).toList();

    return RootCauseResponse(
      status: json['status'],
      data: details,
    );
  }
}

class RootCauseDetail {
  final int id;
  final String name;

  RootCauseDetail({
    required this.id,
    required this.name,
  });

  factory RootCauseDetail.fromJson(Map<String, dynamic> json) {
    return RootCauseDetail(
      id: json['id'],
      name: json['name'],
    );
  }
}