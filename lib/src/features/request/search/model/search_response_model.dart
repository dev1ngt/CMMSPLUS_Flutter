class SearchResponseModel {
  final List<RequestIdItem> requestIdList;
  final bool status;
  final String message;

  SearchResponseModel({
    required this.requestIdList,
    required this.status,
    required this.message,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      requestIdList: (json['request_id_list'] as List)
          .map((e) => RequestIdItem.fromJson(e))
          .toList(),
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id_list': requestIdList.map((e) => e.toJson()).toList(),
      'status': status,
      'message': message,
    };
  }
}

class RequestIdItem {
  final String requestId;

  RequestIdItem({required this.requestId});

  factory RequestIdItem.fromJson(Map<String, dynamic> json) {
    return RequestIdItem(
      requestId: json['request_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
    };
  }
}
