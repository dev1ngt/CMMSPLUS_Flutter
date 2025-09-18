class RequestType {
  bool status;
  List<SelectedType> selectedTypes;
  List<AllType> allTypes;

  RequestType({
    required this.status,
    required this.selectedTypes,
    required this.allTypes,
  });

  factory RequestType.fromJson(Map<String, dynamic> json) {
    return RequestType(
      status: json['status'],
      selectedTypes: (json['selectedTypes'] as List<dynamic>)
          .map((type) => SelectedType.fromJson(type))
          .toList(),
      allTypes: (json['allTypes'] as List<dynamic>)
          .map((type) => AllType.fromJson(type))
          .toList(),
    );
  }
}

class SelectedType {
  int id;
  String requestType;
  int isSelected;

  SelectedType({
    required this.id,
    required this.requestType,
    required this.isSelected,
  });

  factory SelectedType.fromJson(Map<String, dynamic> json) {
    return SelectedType(
      id: json['id'],
      requestType: json['request_type'],
      isSelected: json['is_selected'],
    );
  }
}

class AllType {
  int id;
  String requestType;
  int isSelected;

  AllType({
    required this.id,
    required this.requestType,
    required this.isSelected,
  });

  factory AllType.fromJson(Map<String, dynamic> json) {
    return AllType(
      id: json['id'],
      requestType: json['request_type'],
      isSelected: json['is_selected'],
    );
  }
}