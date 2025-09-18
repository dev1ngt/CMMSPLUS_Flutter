class TaskModel {
  final String status;
  final List<TaskData> data;
  final Count count;

  TaskModel({
    required this.status,
    required this.data,
    required this.count,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<TaskData> tasks = dataList.map((task) => TaskData.fromJson(task)).toList();

    return TaskModel(
      status: json['status'],
      data: tasks,
      count: Count.fromJson(json['count']),
    );
  }
}

class TaskData {
  final int id;
  final String taskNo;
  final String createdDate;
  final String description;
  final String natureOfComplaint;
  final String priority;

  TaskData({
    required this.id,
    required this.taskNo,
    required this.createdDate,
    required this.description,
    required this.natureOfComplaint,
    required this.priority,
  });

  factory TaskData.fromJson(Map<String, dynamic> json) {
    return TaskData(
      id: json['id'],
      taskNo: json['taskNo'],
      createdDate: json['createdDate'],
      description: json['description'],
      natureOfComplaint: json['natureOfComplaint'],
      priority: json['priority'],
    );
  }
}
class Count {
  final int open;
  final int inProgress;
  final int close;
  final int hold;
  final int completed;

  Count({
    required this.open,
    required this.inProgress,
    required this.close,
    required this.hold,
    required this.completed,
  });

  factory Count.fromJson(Map<String, dynamic> json) {
    return Count(
      open: json['open'],
      inProgress: json['inprogress'],
      close: json['close'],
      hold: json['hold'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open': open,
      'inprogress': inProgress,
      'close': close,
      'hold': hold,
      'completed': completed,
    };
  }
}