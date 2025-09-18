class AdhocAddNewViewResponseModel {
  final bool isError;
  final String message;
  final List<AdhocProperty> propertyList;
  final List<SpaceFloor> spaceFloorList;
  final List<InspectionClass> inspectionClassList;


  AdhocAddNewViewResponseModel({
    required this.isError,
    required this.message,
    required this.propertyList,
    required this.spaceFloorList,
    required this.inspectionClassList,

  });

  factory AdhocAddNewViewResponseModel.fromJson(Map<String, dynamic> json) {
    return AdhocAddNewViewResponseModel(
      isError: json['IsError'] ?? false,
      message: json['Message'] ?? '',
      propertyList: (json['PropertyList'] as List)
          .map((e) => AdhocProperty.fromJson(e))
          .toList(),
      spaceFloorList: (json['SpaceFloorList'] as List)
          .map((e) => SpaceFloor.fromJson(e))
          .toList(),
      inspectionClassList: (json['InspectionClassList'] as List)
          .map((e) => InspectionClass.fromJson(e))
          .toList(),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IsError': isError,
      'Message': message,
      'PropertyList': propertyList.map((e) => e.toJson()).toList(),
      'SpaceFloorList': spaceFloorList.map((e) => e.toJson()).toList(),
      'InspectionClassList': inspectionClassList.map((e) => e.toJson()).toList(),

    };
  }
}

class AdhocProperty {
  final int id;
  final String propertyName;

  AdhocProperty({required this.id, required this.propertyName});

  factory AdhocProperty.fromJson(Map<String, dynamic> json) {
    return AdhocProperty(
      id: json['id'],
      propertyName: json['property_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_name': propertyName,
    };
  }
}

class SpaceFloor {
  final int id;
  final String levelName;

  SpaceFloor({required this.id, required this.levelName});

  factory SpaceFloor.fromJson(Map<String, dynamic> json) {
    return SpaceFloor(
      id: json['id'],
      levelName: json['level_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level_name': levelName,
    };
  }
}

class InspectionClass {
  final int id;
  final String templateTitle;

  InspectionClass({required this.id, required this.templateTitle});

  factory InspectionClass.fromJson(Map<String, dynamic> json) {
    return InspectionClass(
      id: json['id'],
      templateTitle: json['template_title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'template_title': templateTitle,
    };
  }
}

class AdhocAsset {
  final int id;
  final String assetName;

  AdhocAsset({required this.id, required this.assetName});

  factory AdhocAsset.fromJson(Map<String, dynamic> json) {
    return AdhocAsset(
      id: json['id'],
      assetName: json['asset_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'asset_name': assetName,
    };
  }
}
