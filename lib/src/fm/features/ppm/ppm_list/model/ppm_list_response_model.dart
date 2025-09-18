class PPMList {
  final String? status;
  final String? message;
  final List<PPMTask>? ppmTask;

  PPMList({
    this.status,
    this.message,
    this.ppmTask,
  });

  factory PPMList.fromJson(Map<String, dynamic> json) {
    var list = json['ppmTask'] as List?;
    List<PPMTask> taskList = list != null ? list.map((i) => PPMTask.fromJson(i)).toList() : [];

    return PPMList(
      status: json['status'],
      message: json['message'],
      ppmTask: taskList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'ppmTask': ppmTask?.map((task) => task.toJson()).toList(),
    };
  }

  static PPMList getMockData() {
    return PPMList(
      status: 'Success',
      message: 'Data retrieved successfully.',
      ppmTask: [
        PPMTask(
          taskNo: '001',
          scheduledDate: '2024-07-01',
          frequency: 'Monthly',
          assetTagNo: 'A001',
          assetName: 'Air Conditioner',
          ppmId: 10,
        ),
        PPMTask(
          taskNo: '002',
          scheduledDate: '2024-07-02',
          frequency: 'Quarterly',
          assetTagNo: 'A002',
          assetName: 'Generator',
          ppmId: 11,
        ),
        // Add more entries as needed
      ],
    );
  }
}

class PPMTask {
  final String? taskNo;
  final String? scheduledDate;
  final String? frequency;
  final String? assetTagNo;
  final String? assetName;
  final int? ppmId;

  PPMTask({
    this.taskNo,
    this.scheduledDate,
    this.frequency,
    this.assetTagNo,
    this.assetName,
    this.ppmId,
  });

  factory PPMTask.fromJson(Map<String, dynamic> json) {
    return PPMTask(
      taskNo: json['taskNo'],
      scheduledDate: json['scheduledDate'],
      frequency: json['frequency'],
      assetTagNo: json['assetTagNo'],
      assetName: json['assetName'],
      ppmId: json['ppmId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskNo': taskNo,
      'scheduledDate': scheduledDate,
      'frequency': frequency,
      'assetTagNo': assetTagNo,
      'assetName': assetName,
      'ppmId': ppmId,
    };
  }
}