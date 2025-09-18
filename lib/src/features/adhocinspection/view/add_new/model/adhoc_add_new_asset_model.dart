class AdhocAddNewAssetModel {
  final bool isError;
  final String message;
  final List<AdhocAssetFilter> assetList;

  AdhocAddNewAssetModel({
    required this.isError,
    required this.message,
    required this.assetList,
  });

  // Factory constructor to parse from JSON
  factory AdhocAddNewAssetModel.fromJson(Map<String, dynamic> json) {
    return AdhocAddNewAssetModel(
      isError: json['IsError'] ?? false,
      message: json['Message'] ?? '',
      assetList: (json['AssetList'] as List)
          .map((item) => AdhocAssetFilter.fromJson(item))
          .toList(),
    );
  }
}

class AdhocAssetFilter {
  final int id;
  final String assetName;

  AdhocAssetFilter({
    required this.id,
    required this.assetName,
  });

  // Factory constructor to parse from JSON
  factory AdhocAssetFilter.fromJson(Map<String, dynamic> json) {
    return AdhocAssetFilter(
      id: json['id'] ?? 0,
      assetName: json['asset_name'] ?? '',
    );
  }
}
