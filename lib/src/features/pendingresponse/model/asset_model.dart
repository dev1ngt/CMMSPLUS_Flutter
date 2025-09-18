class AssetResponse {
  final String status;
  final String message;
  final AssetData assetData;

  AssetResponse({
    required this.status,
    required this.message,
    required this.assetData,
  });

  factory AssetResponse.fromJson(Map<String, dynamic> json) {
    return AssetResponse(
      status: json['status'],
      message: json['message'],
      assetData: AssetData.fromJson(json['asset_data']),
    );
  }
}

class AssetData {
  final int assetId;
  final String assetName;
  final String assetCode;

  AssetData({
    required this.assetId,
    required this.assetName,
    required this.assetCode,
  });

  factory AssetData.fromJson(Map<String, dynamic> json) {
    return AssetData(
      assetId: json['asset_id'],
      assetName: json['asset_name'],
      assetCode: json['asset_code'],
    );
  }
}

class AssetInput {
  String? id;
  String? propertyId; // Added propertyId

  AssetInput({
    this.id,
    this.propertyId, // Added to constructor
  });

  factory AssetInput.fromJson(Map<String, dynamic> json) => AssetInput(
    id: json["id"],
    propertyId: json["propertyId"], // Deserialize
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "propertyId": propertyId, // Serialize
  };
}