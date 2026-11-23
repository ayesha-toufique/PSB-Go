
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/announcement_model.dart';
import 'auth_service.dart';

class AnnouncementService {
  final String baseUrl = AuthService.baseUrl;

  Future<List<AnnouncementModel>> getAnnouncements() async {
    final response = await http.get(
      Uri.parse('$baseUrl/announcements'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List announcements = data['announcements'] ?? [];

      return announcements
          .map(
            (item) => AnnouncementModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    }

    throw Exception('Unable to load announcements.');
  }
}
