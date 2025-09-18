// task_model.dart

class CMDetailsResponseModel {
  final String status;
  final TaskData data;

  CMDetailsResponseModel({
    required this.status,
    required this.data,
  });

  factory CMDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return CMDetailsResponseModel(
      status: json['status'],
      data: TaskData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class TaskData {
  final int id;
  final String taskNo;
  final String createdDate;
  final String description;
  final String natureOfComplaint;
  final String priority;
  final String location;
  final String building;
  final String floor;
  final String area;
  final String responseTime;
  final String fixTime;
  final String assetTagNo;
  final String assetName;

  TaskData({
    required this.id,
    required this.taskNo,
    required this.createdDate,
    required this.description,
    required this.natureOfComplaint,
    required this.priority,
    required this.location,
    required this.building,
    required this.floor,
    required this.area,
    required this.responseTime,
    required this.fixTime,
    required this.assetTagNo,
    required this.assetName,
  });

  factory TaskData.fromJson(Map<String, dynamic> json) {
    return TaskData(
      id: json['id'],
      taskNo: json['taskNo'],
      createdDate: json['createdDate'],
      description: json['description'],
      natureOfComplaint: json['natureOfComplaint'],
      priority: json['priority'],
      location: json['location'],
      building: json['building'],
      floor: json['floor'],
      area: json['area'],
      responseTime: json['responseTime'],
      fixTime: json['fixTime'],
      assetTagNo: json['assetTagNo'],
      assetName: json['assetName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskNo': taskNo,
      'createdDate': createdDate,
      'description': description,
      'natureOfComplaint': natureOfComplaint,
      'priority': priority,
      'location': location,
      'building': building,
      'floor': floor,
      'area': area,
      'responseTime': responseTime,
      'fixTime': fixTime,
      'assetTagNo': assetTagNo,
      'assetName': assetName,
    };
  }
}