class CMMaterialModel {
  final String status;
  final List<AllEmpListI> data;
  final List<AssignedEmployeeListI> assignedEmployee;

  CMMaterialModel({
    required this.status,
    required this.data,
    required this.assignedEmployee,
  });

  factory CMMaterialModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<AllEmpListI> parsedDataList = dataList.map((item) => AllEmpListI.fromJson(item)).toList();

    var assignedEmployeeList = json['assignedEmployee'] as List;
    List<AssignedEmployeeListI> parsedAssignedEmployeeList =
    assignedEmployeeList.map((item) => AssignedEmployeeListI.fromJson(item)).toList();

    return CMMaterialModel(
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

class AllEmpListI {
  final int id;
  final String name;

  AllEmpListI({
    required this.id,
    required this.name,
  });

  factory AllEmpListI.fromJson(Map<String, dynamic> json) {
    return AllEmpListI(
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

class AssignedEmployeeListI {
  final int id;
  final String name;

  AssignedEmployeeListI({
    required this.id,
    required this.name,
  });

  factory AssignedEmployeeListI.fromJson(Map<String, dynamic> json) {
    return AssignedEmployeeListI(
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