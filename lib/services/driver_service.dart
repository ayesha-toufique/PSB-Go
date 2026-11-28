import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/bus_model.dart';
import '../models/route_model.dart';
import 'auth_service.dart';

class DriverService {
  final String baseUrl = AuthService.baseUrl;

  Future<Map<String, String>> _headers() async {
    final token = await AuthService().getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Your session has expired. Please login again.');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _decode(http.Response response) {
    final data = jsonDecode(response.body);

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid server response.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        data['message']?.toString() ?? 'Request failed.',
      );
    }

    return data;
  }

  // Get buses assigned to the logged-in driver
  Future<List<BusModel>> getMyBuses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/driver/my-buses'),
      headers: await _headers(),
    );

    final data = _decode(response);
    final List buses = data['buses'] ?? [];

    return buses
        .map(
          (item) => BusModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  // Get all available routes from backend
  Future<List<RouteModel>> getRoutes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/routes'),
      headers: await _headers(),
    );

    final data = _decode(response);
    final List routes = data['routes'] ?? [];

    return routes
        .map(
          (item) => RouteModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  // Get the driver's active journey
  Future<Map<String, dynamic>?> getActiveTrip() async {
    final response = await http.get(
      Uri.parse('$baseUrl/driver/active-trip'),
      headers: await _headers(),
    );

    final data = _decode(response);
    final trip = data['trip'];

    if (trip == null) return null;

    return Map<String, dynamic>.from(trip);
  }

  // Start a journey
  Future<Map<String, dynamic>> startJourney({
    required String busId,
    required String routeId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/driver/start-journey'),
      headers: await _headers(),
      body: jsonEncode({
        'busId': busId,
        'routeId': routeId,
      }),
    );

    final data = _decode(response);

    return Map<String, dynamic>.from(data['trip']);
  }

  // End a journey
  Future<void> endJourney(String tripId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/driver/end-journey/$tripId'),
      headers: await _headers(),
    );

    _decode(response);
  }
}