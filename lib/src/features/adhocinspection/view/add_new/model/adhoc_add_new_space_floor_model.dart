class AdhocAddNewSpaceFloorModel {
  final bool isError;
  final String message;
  final String regionName;
  final List<SpaceFloorFilter> levelList;

  AdhocAddNewSpaceFloorModel({
    required this.isError,
    required this.message,
    required this.regionName,
    required this.levelList,
  });

  // Factory constructor to parse from JSON
  factory AdhocAddNewSpaceFloorModel.fromJson(Map<String, dynamic> json) {
    return AdhocAddNewSpaceFloorModel(
      isError: json['IsError'] ?? false,
      message: json['Message'] ?? '',
      regionName: json['regionName'] ?? '',
      levelList: (json['SpaceFloorList'] as List)
          .map((item) => SpaceFloorFilter.fromJson(item))
          .toList(),
    );
  }
}

class SpaceFloorFilter {
  final int id;
  final String levelName;

  SpaceFloorFilter({
    required this.id,
    required this.levelName,
  });

  // Factory constructor to parse from JSON
  factory SpaceFloorFilter.fromJson(Map<String, dynamic> json) {
    return SpaceFloorFilter(
      id: json['id'] ?? 0,
      levelName: json['level_name'] ?? '',
    );
  }
}
