class PPMStatusModel {
  final String status;
  final PPMCount count;

  PPMStatusModel({
    required this.status,
    required this.count,
  });

  factory PPMStatusModel.fromJson(Map<String, dynamic> json) {
    return PPMStatusModel(
      status: json['status'],
      count: PPMCount.fromJson(json['count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'count': count.toJson(),
    };
  }
}
class PPMCount {
  final int open;
  final int inProgress;
  final int close;
  final int hold;
  final int completed;

  PPMCount({
    required this.open,
    required this.inProgress,
    required this.close,
    required this.hold,
    required this.completed,
  });

  factory PPMCount.fromJson(Map<String, dynamic> json) {
    return PPMCount(
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