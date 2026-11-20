
class RouteStop {
  final String id;
  final String name;
  final int order;

  RouteStop({
    required this.id,
    required this.name,
    required this.order,
  });

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    final stopData = json['stopId'];

    if (stopData is Map<String, dynamic>) {
      return RouteStop(
        id: stopData['_id']?.toString() ?? '',
        name: stopData['name']?.toString() ?? 'Unknown stop',
        order: (json['order'] as num?)?.toInt() ?? 0,
      );
    }

    return RouteStop(
      id: stopData?.toString() ?? '',
      name: 'Stop information unavailable',
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }
}

class RouteModel {
  final String id;
  final String name;
  final String description;
  final List<RouteStop> stops;

  RouteModel({
    required this.id,
    required this.name,
    required this.description,
    required this.stops,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final stopsData = json['stops'] as List? ?? [];

    final parsedStops = stopsData
        .whereType<Map<String, dynamic>>()
        .map(RouteStop.fromJson)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    return RouteModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unnamed route',
      description: json['description']?.toString() ?? '',
      stops: parsedStops,
    );
  }
}
