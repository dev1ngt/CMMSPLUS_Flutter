// task_model.dart

class PPMDetailsResponseModelOne {
  final String status;
  final PPMDetData data;

  PPMDetailsResponseModelOne({
    required this.status,
    required this.data,
  });

  factory PPMDetailsResponseModelOne.fromJson(Map<String, dynamic> json) {
    return PPMDetailsResponseModelOne(
      status: json['status'],
      data: PPMDetData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }

  static PPMDetailsResponseModelOne getMockData() {
    return PPMDetailsResponseModelOne(
      status: 'Success',
      data: PPMDetData(
        id: 1,
        ppmTaskNo: 'TASK12345',
        scheduleDate: '2024-07-22',
        frequency: 'Monthly',
        category: 'Electrical',
        subCategory: 'Level - 1',
        location: 'Main Building',
        building: 'Building A',
        floor: '2nd Floor',
        area: 'Room 202',
        assetTagNo: 'AC-12345',
        assetNo: '232323',
        assetName: 'Air Conditioner',
        isQrcode: true
      ),
    );
  }

}

class PPMDetData {
  final int id;
  final String ppmTaskNo;
  final String scheduleDate;
  final String frequency;
  final String category;
  final String subCategory;
  final String location;
  final String building;
  final String floor;
  final String area;
  final String assetTagNo;
  final String assetNo;
  final String assetName;
  final bool isQrcode;


  PPMDetData({
    required this.id,
    required this.ppmTaskNo,
    required this.scheduleDate,
    required this.frequency,
    required this.category,
    required this.subCategory,
    required this.location,
    required this.building,
    required this.floor,
    required this.area,
    required this.assetTagNo,
    required this.assetNo,
    required this.assetName,
    required this.isQrcode,
  });

  factory PPMDetData.fromJson(Map<String, dynamic> json) {
    return PPMDetData(
      id: json['id'],
      ppmTaskNo: json['ppmTaskNo'],
      scheduleDate: json['scheduleDate'],
      frequency: json['frequency'],
      category: json['category'],
      subCategory: json['subCategory'],
      location: json['location'],
      building: json['building'],
      floor: json['floor'],
      area: json['area'],
      assetTagNo: json['assetTagNo'],
      assetNo: json['assetNo'],
      assetName: json['assetName'],
      isQrcode: json['isQrcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ppmTaskNo': ppmTaskNo,
      'scheduleDate': scheduleDate,
      'frequency': frequency,
      'category': category,
      'subCategory': subCategory,
      'location': location,
      'building': building,
      'floor': floor,
      'area': area,
      'assetTagNo': assetTagNo,
      'assetNo': assetNo,
      'assetName': assetName,
      'isQrcode': isQrcode,
    };
  }
}