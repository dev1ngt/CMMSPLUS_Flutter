class PropertyModel {
  final bool status;
  final String message;
  final List<Property> property;

  PropertyModel({
    required this.status,
    required this.message,
    required this.property,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    var list_ = json['property'] as List;
    List<Property> property_status = list_.map((i) => Property.fromJson(i)).toList();

    return PropertyModel(
      status: json['status'],
      message: json['message'],
      property: property_status,
    );
  }
}

class Property {
  final int proid;
  final String proname;

  Property({
    required this.proid,
    required this.proname,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      proid: json['proid'],
      proname: json['proname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'proid': proid,
      'proname': proname,
    };
  }
}