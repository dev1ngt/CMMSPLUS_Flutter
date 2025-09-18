class AssetsResponse {
  final List<Assets> assets;
  final bool status;
  final String message;

  AssetsResponse({required this.assets, required this.status, required this.message});

  factory AssetsResponse.fromJson(Map<String, dynamic> json) {
    var assetsJson = json['assets'];

    List<Assets> assetsList = [];
    if (assetsJson is List) {
      assetsList = assetsJson.map((e) => Assets.fromJson(e)).toList();
    }

    return AssetsResponse(
      assets: assetsList,
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? "",
    );
  }
}

class Assets {
  final int assetId;
  final String assetName;
  final String assetCode;
  Assets({
    required this.assetId,
    required this.assetName,
    required this.assetCode,
  });

  factory Assets.fromJson(Map<String, dynamic> json) {
    return Assets(
      assetId: json['asset_id'],
      assetName: json['asset_name']?.toString() ?? "",
      assetCode: json['asset_code']?.toString() ?? "",
    );
  }
}



class MultiAssetInput {
  String? id;


  MultiAssetInput({
    this.id,
  });

  factory MultiAssetInput.fromJson(Map<String, dynamic> json) => MultiAssetInput(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,

  };
}