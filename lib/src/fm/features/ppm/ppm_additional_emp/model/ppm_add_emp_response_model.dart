class PPMAdditionalEmployeeModel {
  final String status;
  final List<PPMAllEmpList> data;
  final List<PPMAssignedEmployeeList> assignedEmployee;

  PPMAdditionalEmployeeModel({
    required this.status,
    required this.data,
    required this.assignedEmployee,
  });

  factory PPMAdditionalEmployeeModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<PPMAllEmpList> parsedDataList = dataList.map((item) => PPMAllEmpList.fromJson(item)).toList();

    var assignedEmployeeList = json['assignedEmployee'] as List;
    List<PPMAssignedEmployeeList> parsedAssignedEmployeeList =
    assignedEmployeeList.map((item) => PPMAssignedEmployeeList.fromJson(item)).toList();

    return PPMAdditionalEmployeeModel(
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

  // Method to create mock data
  static PPMAdditionalEmployeeModel mockData() {
    return PPMAdditionalEmployeeModel(
      status: "success",
      data: [
        PPMAllEmpList(id: 1, name: "John Doe"),
        PPMAllEmpList(id: 2, name: "Jane Smith"),
      ],
      assignedEmployee: [
        PPMAssignedEmployeeList(id: 3, name: "Mike Johnson"),
        PPMAssignedEmployeeList(id: 4, name: "Emily Davis"),
      ],
    );
  }
}





class PPMAllEmpList {
  final int id;
  final String name;

  PPMAllEmpList({
    required this.id,
    required this.name,
  });

  factory PPMAllEmpList.fromJson(Map<String, dynamic> json) {
    return PPMAllEmpList(
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

class PPMAssignedEmployeeList {
  final int id;
  final String name;

  PPMAssignedEmployeeList({
    required this.id,
    required this.name,
  });

  factory PPMAssignedEmployeeList.fromJson(Map<String, dynamic> json) {
    return PPMAssignedEmployeeList(
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