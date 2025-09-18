class SubtypeResponseModel {
  final bool status;
  final List<SubtypeData> data;

  SubtypeResponseModel({
    required this.status,
    required this.data,
  });

  factory SubtypeResponseModel.fromJson(Map<String, dynamic> json) {
    return SubtypeResponseModel(
      status: json['status'],
      data: (json['data'] as List)
          .map((item) => SubtypeData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class SubtypeData {
  final int id;
  final String text;
  final int isSelected;

  SubtypeData({
    required this.id,
    required this.text,
    required this.isSelected,
  });

  factory SubtypeData.fromJson(Map<String, dynamic> json) {
    return SubtypeData(
      id: json['id'],
      text: json['text'],
      isSelected: json['is_selected'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'is_selected': isSelected,
    };
  }
}
