


class PPMBarcodeResponseModel {
  final String status;
  final PPMBarcodeData data;

  PPMBarcodeResponseModel({
    required this.status,
    required this.data,
  });

  factory PPMBarcodeResponseModel.fromJson(Map<String, dynamic> json) {
    return PPMBarcodeResponseModel(
      status: json['status'],
      data: PPMBarcodeData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }

  static PPMBarcodeResponseModel getMockData() {
    return PPMBarcodeResponseModel(
      status: 'Success',
      data: PPMBarcodeData(
        id: 1,
        ppmtaskNo: 'TASK12345',
        assetBarcode: '234445555533',
        assetTagNo: 'AC-12345',
        assetName: 'Air Conditioner',
        isBarcodeValidate: 1,
      ),
    );
  }

}

class PPMBarcodeData {
  final int id;
  final String ppmtaskNo;
  final String assetBarcode;
  final String assetTagNo;
  final String assetName;
  final int isBarcodeValidate;

  PPMBarcodeData({
    required this.id,
    required this.ppmtaskNo,
    required this.assetBarcode,
    required this.assetTagNo,
    required this.assetName,
    required this.isBarcodeValidate,
  });

  factory PPMBarcodeData.fromJson(Map<String, dynamic> json) {
    return PPMBarcodeData(
      id: json['id'],
      ppmtaskNo: json['ppmtaskNo'],
      assetBarcode: json['area'],
      assetTagNo: json['assetTagNo'],
      assetName: json['assetName'],
      isBarcodeValidate: json['isBarcodeValidate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ppmtaskNo': ppmtaskNo,
      'assetBarcode': assetBarcode,
      'assetTagNo': assetTagNo,
      'assetName': assetName,
      'isBarcodeValidate':isBarcodeValidate
    };
  }


}



class SubmitDefectInput {
  int? ppmid;
  int? user_id;
  String? description;


  SubmitDefectInput({
    this.ppmid,
    this.user_id,
    this.description,

  });

  factory SubmitDefectInput.fromJson(Map<String, dynamic> json) => SubmitDefectInput(
    ppmid: json["ppmid"],
    user_id: json["user_id"],
    description: json["description"],

  );

  Map<String, dynamic> toJson() => {
    "ppmid": ppmid,
    "user_id": user_id,
    "description": description,
  };}

