
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/route_model.dart';

class RouteService {
  // Same backend URL as your AuthService.
  static const String baseUrl = 'http://localhost:5005/api';

  Future<List<RouteModel>> getRoutes() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/routes'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List routesData = data['routes'] ?? [];

        return routesData
            .map(
              (route) => RouteModel.fromJson(
                Map<String, dynamic>.from(route),
              ),
            )
            .toList();
      }

      throw Exception(
        data['message'] ?? 'Unable to load routes.',
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Something went wrong while loading routes.');
    }
  }
}
