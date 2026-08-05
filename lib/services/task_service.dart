import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';
import 'client_service.dart';


class TaskService {

      
  Future<List<Task>> getAllTasks() async {
    final prefs =
          await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('Utilisateur non authentifié');

    final response = await http.get(
      Uri.parse("${ClientService.baseUrl}/tasks"),
      headers: {
        "Accept":"application/json",
        "Content-Type":"application/json",
        "Authorization": "Bearer $token",
      },
    );

    if(response.statusCode == 200){
      final List<dynamic> json = jsonDecode(response.body);
      final List<Task> tasks = json.map((e) => Task.fromJson(e)).toList();
      return tasks;
    }else{
      final error =
          jsonDecode(response.body);
      throw Exception(
          error['message']
      );
    }
  }


    Future <Task> getTaskById(String id) async {
    final prefs =
          await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token == null) throw Exception('Utilisateur non authentifié');

    final response = await http.get(
      Uri.parse("${ClientService.baseUrl}/tasks/$id"),
      headers: {
        "Accept":"application/json",
        "Content-Type":"application/json",
        "Authorization": "Bearer $token",
      },
    );

    if(response.statusCode == 200){
      final Map<String , dynamic> json = jsonDecode(response.body);
      final Task task = Task.fromJson(json);
      return task;
    }else{
      final error =
          jsonDecode(response.body);
      throw Exception(
          error['message']
      );
    }
  }
}