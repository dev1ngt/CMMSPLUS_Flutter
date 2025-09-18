class AssetResponseModel {
  final bool status;
  final String message;
  final String url;

  AssetResponseModel({
    required this.status,
    required this.message,
    required this.url,
  });

  factory AssetResponseModel.fromJson(Map<String, dynamic> json) {
    return AssetResponseModel(
      status: json['status'].toString().toLowerCase() == 'true',
      message: json['message'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.toString(),
      'message': message,
      'url': url,
    };
  }
}