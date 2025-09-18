class PPMDetailsTempModel {
  List<int>? assetID; // Change to nullable type
  List<String>? assetName; // Change to nullable type

  PPMDetailsTempModel({
    this.assetID, // Change to nullable parameter
    this.assetName, // Change to nullable parameter
  });

  // Create a factory constructor for JSON deserialization
  factory PPMDetailsTempModel.fromJson(Map<String, dynamic> json) {
    return PPMDetailsTempModel(
      assetID: json['asset_id'] != null ? List<int>.from(json['asset_id']) : null,
      assetName: json['asset_name'] != null ? List<String>.from(json['asset_name']) : null,
    );
  }

  // Create a method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'asset_id': assetID,
      'asset_name': assetName,
    };
  }
}