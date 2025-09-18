class PriorityResponseModel {
  final bool status;
  final String message;
  final PriorityData? data;

  PriorityResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory PriorityResponseModel.fromJson(Map<String, dynamic> json) {
    return PriorityResponseModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? PriorityData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class PriorityData {
  final int priorityId;
  final String priorityName;
  final int maxFile;
  final List<MultipleImage> multipleImage;
  final String regionName;

  PriorityData({
    required this.priorityId,
    required this.priorityName,
    required this.maxFile,
    required this.multipleImage,
    required this.regionName,
  });

  factory PriorityData.fromJson(Map<String, dynamic> json) {
    return PriorityData(
      priorityId: json['priority_id'] as int,
      priorityName: json['priority_name'] as String,
      maxFile: json['max_file'] as int,
      regionName: json['regionName'] as String,
      multipleImage: (json['multipleimage'] as List<dynamic>)
          .map((e) => MultipleImage.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'priority_id': priorityId,
      'priority_name': priorityName,
      'max_file': maxFile,
      'multipleimage': multipleImage.map((e) => e.toJson()).toList(),
      'regionName': regionName,
    };
  }
}

class MultipleImage {
  final int id;
  final String type;
  final String path;

  MultipleImage({
    required this.id,
    required this.type,
    required this.path,
  });

  factory MultipleImage.fromJson(Map<String, dynamic> json) {
    return MultipleImage(
      id: json['id'] as int,
      type: json['type'] as String,
      path: json['path'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'path': path,
    };
  }
}
