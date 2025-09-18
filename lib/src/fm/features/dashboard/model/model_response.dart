class ModuleResponse {
  String status;
  List<Module> module;

  ModuleResponse({
    required this.status,
    required this.module,
  });

  factory ModuleResponse.fromJson(Map<String, dynamic> json) {
    var modulesList = json['module'] as List<dynamic>;
    List<Module> modules = modulesList.map((e) => Module.fromJson(e)).toList();

    return ModuleResponse(
      status: json['status'] ?? '',
      module: modules,
    );
  }

  // Static method to provide mock data
  static ModuleResponse getMockData() {
    return ModuleResponse(
      status: 'success',
      module: [
        Module(
          title: 'CM',
          open: 5,
          inProgress: 3,
          close: 2,
          hold: 1,
          completed: 0,
          total: 11,
        ),
        Module(
          title: 'PPM',
          open: 4,
          inProgress: 2,
          close: 6,
          hold: 0,
          completed: 0,
          total: 12,
        ),
        Module(
          title: 'BDM',
          open: 7,
          inProgress: 4,
          close: 3,
          hold: 2,
          completed: 0,
          total: 16,
        ),
      ],
    );
  }
}
class Module {
  final String title;
  final int open;
  final int inProgress;
  final int close;
  final int hold;
  final int completed;
  final int total;

  Module({
    required this.title,
    required this.open,
    required this.inProgress,
    required this.close,
    required this.hold,
    required this.completed,
    required this.total,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      title: json['title'],
      open: json['open'],
      inProgress: json['inprogress'],
      close: json['close'],
      hold: json['hold'],
      completed: json['completed'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'open': open,
      'inprogress': inProgress,
      'close': close,
      'hold': hold,
      'completed': completed,
      'total': total,
    };
  }
}