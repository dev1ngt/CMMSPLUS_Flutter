class ComplainerData {
  final String status;
  final String message;
  final List<Complainer> complainer;
  final List<NatureOfComplaint> natureOfComplaints;

  ComplainerData({
    required this.status,
    required this.message,
    required this.complainer,
    required this.natureOfComplaints,
  });

  factory ComplainerData.fromJson(Map<String, dynamic> json) {
    return ComplainerData(
      status: json['status'],
      message: json['message'],
      complainer: (json['complainer'] as List)
          .map((data) => Complainer.fromJson(data))
          .toList(),
      natureOfComplaints: (json['natureOfComplaints'] as List)
          .map((data) => NatureOfComplaint.fromJson(data))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'complainer': complainer.map((data) => data.toJson()).toList(),
      'natureOfComplaints':
      natureOfComplaints.map((data) => data.toJson()).toList(),
    };
  }
}

class Complainer {
  final int id;
  final String name;
  final String email;
  final String mobile;
  final Location location;

  Complainer({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.location,
  });

  factory Complainer.fromJson(Map<String, dynamic> json) {
    return Complainer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'location': location.toJson(),
    };
  }
}

class Location {
  final int id;
  final String name;

  Location({
    required this.id,
    required this.name,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
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

class NatureOfComplaint {
  final int id;
  final String name;

  NatureOfComplaint({
    required this.id,
    required this.name,
  });

  factory NatureOfComplaint.fromJson(Map<String, dynamic> json) {
    return NatureOfComplaint(
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

class ComplaintSubmitInput {
  int? natureofcomplaint_id;
  int? complainer_id;
  String? description;
  int? user_id;

  ComplaintSubmitInput({
    this.natureofcomplaint_id,
    this.complainer_id,
    this.description,
    this.user_id,
  });

  factory ComplaintSubmitInput.fromJson(Map<String, dynamic> json) => ComplaintSubmitInput(
    natureofcomplaint_id: json["natureofcomplaint_id"],
    complainer_id: json["complainer_id"],
    description: json["description"],
    user_id: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "natureofcomplaint_id": natureofcomplaint_id,
    "complainer_id": complainer_id,
    "description": description,
    "user_id": user_id,
  };
}