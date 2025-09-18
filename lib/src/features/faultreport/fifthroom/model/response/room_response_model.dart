class RoomResponse {
  bool status;
  List<Room> rooms;

  RoomResponse({required this.status, required this.rooms});

  factory RoomResponse.fromJson(Map<String, dynamic> json) {
    return RoomResponse(
      status: json['status'],
      rooms: (json['Room'] as List).map((room) => Room.fromJson(room)).toList(),
    );
  }
}

class Room {
  int id;
  String text;
  int isSelected;

  Room({required this.id, required this.text, required this.isSelected});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      text: json['text'],
      isSelected: json['is_selected'],
    );
  }
}