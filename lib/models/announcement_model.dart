
class AnnouncementModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime? createdAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['type']?.toString() ?? 'info',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
