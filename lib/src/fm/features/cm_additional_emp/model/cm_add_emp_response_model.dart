class CMAdditionalEmployeeModel {
  final String status;
  final List<AllEmpList> data;
  final List<AssignedEmployeeList> assignedEmployee;

  CMAdditionalEmployeeModel({
    required this.status,
    required this.data,
    required this.assignedEmployee,
  });

  factory CMAdditionalEmployeeModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<AllEmpList> parsedDataList = dataList.map((item) => AllEmpList.fromJson(item)).toList();

    var assignedEmployeeList = json['assignedEmployee'] as List;
    List<AssignedEmployeeList> parsedAssignedEmployeeList =
    assignedEmployeeList.map((item) => AssignedEmployeeList.fromJson(item)).toList();

    return CMAdditionalEmployeeModel(
      status: json['status'],
      data: parsedDataList,
      assignedEmployee: parsedAssignedEmployeeList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
      'assignedEmployee': assignedEmployee.map((item) => item.toJson()).toList(),
    };
  }
}

class AllEmpList {
  final int id;
  final String name;

  AllEmpList({
    required this.id,
    required this.name,
  });

  factory AllEmpList.fromJson(Map<String, dynamic> json) {
    return AllEmpList(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class AssignedEmployeeList {
  final int id;
  final String name;

  AssignedEmployeeList({
    required this.id,
    required this.name,
  });

  factory AssignedEmployeeList.fromJson(Map<String, dynamic> json) {
    return AssignedEmployeeList(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}