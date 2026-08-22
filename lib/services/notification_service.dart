import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_notification.dart';
import 'client_service.dart';

class NotificationService {
  Future<String> _requireToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Utilisateur non authentifié');
    return token;
  }

  // Réponse paginée Laravel (paginate(20)->through(...)) : les notifications
  // sont dans json['data'], pas un tableau brut.
  Future<List<AppNotification>> getNotifications({bool unreadOnly = false}) async {
    final token = await _requireToken();

    final uri = Uri.parse("${ClientService.baseUrl}/notifications").replace(
      queryParameters: unreadOnly ? {'filter': 'unread'} : null,
    );

    final response = await http.get(
      uri,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      return data.map((e) => AppNotification.fromJson(e)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  Future<int> getUnreadCount() async {
    final token = await _requireToken();

    final response = await http.get(
      Uri.parse("${ClientService.baseUrl}/notifications/unread-count"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['unread_count'] ?? 0;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  Future<void> markAsRead(String id) async {
    final token = await _requireToken();

    final response = await http.patch(
      Uri.parse("${ClientService.baseUrl}/notifications/$id/read"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  Future<void> markAllAsRead() async {
    final token = await _requireToken();

    final response = await http.post(
      Uri.parse("${ClientService.baseUrl}/notifications/read-all"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }
}
