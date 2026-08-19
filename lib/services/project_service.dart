import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/project.dart';
import 'client_service.dart';

class ProjectService {
  Future<String> _requireToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Utilisateur non authentifié');
    return token;
  }

  Future<List<Project>> getProjects() async {
    final token = await _requireToken();

    final response = await http.get(
      Uri.parse("${ClientService.baseUrl}/projects"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Project.fromJson(e)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  // Seule route qui expose une liste d'utilisateurs (id + nom) côté API :
  // pas d'endpoint /users dédié, donc on passe par les membres d'un projet
  // pour peupler le choix des participants d'une conversation.
  Future<List<ProjectMember>> getProjectMembers(int projectId) async {
    final token = await _requireToken();

    final response = await http.get(
      Uri.parse("${ClientService.baseUrl}/projects/$projectId"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> members = json['members'] ?? [];
      return members.map((e) => ProjectMember.fromJson(e)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }
}
