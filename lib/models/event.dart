class Event {
  final int id;
  final String name;
  final String description;

  Event({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Không có tên',
      description: json['description'] as String? ?? 'Không có mô tả',
    );
  }
}