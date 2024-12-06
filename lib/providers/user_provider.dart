import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  // Function to log the user in and store their info
  Future<bool> login(String id, String password) async {
    final url = Uri.parse('${AppColors.baseUrl}/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];

        // Parse user from response
        User user = User.fromJson(
          data['user'],
        );

        // Store user in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user', jsonEncode(user.toJson()));

        state = user; // Update Riverpod state with the new user data

        return true;
      } else {
        final errorData = jsonDecode(response.body);
        print('Login failed: ${errorData['message']}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // Other methods (e.g., logout, loadUser) remain the same...
}
