
class BusModel {
  final String id;
  final String registrationNumber;
  final int capacity;
  final bool isActive;
  final String? currentRouteId;
  final String? currentRouteName;

  BusModel({
    required this.id,
    required this.registrationNumber,
    required this.capacity,
    required this.isActive,
    this.currentRouteId,
    this.currentRouteName,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    final currentRoute = json['currentRoute'];

    return BusModel(
      id: json['_id']?.toString() ?? '',
      registrationNumber:
          json['registrationNumber']?.toString() ?? '',
      capacity: (json['capacity'] as num?)?.toInt() ?? 40,
      isActive: json['isActive'] == true,
      currentRouteId: currentRoute is Map
          ? currentRoute['_id']?.toString()
          : currentRoute?.toString(),
      currentRouteName: currentRoute is Map
          ? currentRoute['name']?.toString()
          : null,
    );
  }
}
