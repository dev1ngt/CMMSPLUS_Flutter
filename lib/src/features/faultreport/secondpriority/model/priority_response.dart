class Priority {
  int id;
  String name;

  Priority({
    required this.id,
    required this.name,
  });

  factory Priority.fromJson(Map<String, dynamic> json) {
    return Priority(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class PrioritiesResponse {
  List<Priority> priorities;
  bool status;

  PrioritiesResponse({
    required this.priorities,
    required this.status,
  });

  factory PrioritiesResponse.fromJson(Map<String, dynamic> json) {
    return PrioritiesResponse(
      priorities: (json['priorities'] as List)
          .map((priority) => Priority.fromJson(priority))
          .toList(),
      status: json['status'] as bool,
    );
  }
}