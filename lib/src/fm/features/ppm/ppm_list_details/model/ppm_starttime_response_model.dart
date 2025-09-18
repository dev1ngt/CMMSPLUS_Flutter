 class PPMStartTimeResponseModel {

   final String status;
   final String message;

   PPMStartTimeResponseModel({
     required this.status,
     required this.message,
   });

   factory PPMStartTimeResponseModel.fromJson(Map<String, dynamic> json) {
     return PPMStartTimeResponseModel(
       status: json['status'],
      message: json['message'],
     );
   }
 }
