 class StartTimeResponseModel {

   final String status;
   final String message;

   StartTimeResponseModel({
     required this.status,
     required this.message,
   });

   factory StartTimeResponseModel.fromJson(Map<String, dynamic> json) {
     return StartTimeResponseModel(
       status: json['status'],
      message: json['message'],
     );
   }
 }
