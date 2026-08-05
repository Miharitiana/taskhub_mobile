import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_response.dart';
import 'client_service.dart';


class AuthService {
      
  Future<LoginResponse> login(
      String email,
      String password
  ) async {
    final response = await http.post(
      Uri.parse("${ClientService.baseUrl}/auth/login"),
      headers: {
        "Accept":"application/json",
        "Content-Type":"application/json",
      },

      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );


    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      final loginResponse =
          LoginResponse.fromJson(json);
      // sauvegarde token
      final prefs =
          await SharedPreferences.getInstance();
      await prefs.setString(
          "token",
          loginResponse.token
      );
      return loginResponse;
    }else{
      final error =
          jsonDecode(response.body);
      throw Exception(
          error['message']
      );
    }
  }
}