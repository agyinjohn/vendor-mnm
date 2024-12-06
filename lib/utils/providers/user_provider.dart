import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<String?> {
  AuthNotifier() : super(null) {
    loadToken(); // Load token on initialization
  }
  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  // Load token from SharedPreferences
  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Retrieve the token
    if (token != null) {
      print("token has expires:${isTokenExpired(token)}");
      if (isTokenExpired(token)) {
        state = null;
      } else {
        state = token;
      }
    }
    print(state);
  }

  // Save token to SharedPreferences
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token); // Save token to local storage
    state = token; // Update Riverpod state with token
  }

  // Clear token on logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove token from storage
    state = null; // Clear Riverpod state
  }

  // Check if user is authenticated by verifying token existence
  bool isAuthenticated() {
    return state != null;
  }
}
