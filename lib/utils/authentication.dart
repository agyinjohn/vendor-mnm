import 'dart:async';
import 'dart:convert'; // For jsonEncode
import 'package:http/http.dart' as http;
import 'package:mnm_vendor/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  // Login method

  // Signup method remains unchanged
  Future<String> signup({
    required String email,
    required String password,
    required String role,
    required String name,
    required String phoneNumber,
  }) async {
    var url = Uri.parse('${AppColors.baseUrl}/signup');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      'email': email,
      'password': password,
      'role': role,
      'name': name,
      'phoneNumber': phoneNumber,
    };

    try {
      final response = await http
          .post(
        url,
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, please try again');
      });

      if (response.statusCode == 201) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        var resDeco = jsonDecode(response.body)['verificationId'];
        preferences.setString('verificationId', resDeco);
        print(resDeco);
        return 'Signup Successful';
      } else {
        return jsonDecode(response.body)['message'];
      }
    } on TimeoutException catch (_) {
      return 'The connection has timed out, please try again';
    } catch (error) {
      print(error);
      return 'Something went wrong please try again later';
    }
  }

  // Verify Token method remains unchanged
  Future<bool> verifyToken(
      String verificationId, String verificationCode) async {
    var url = Uri.parse('${AppColors.baseUrl}/verify');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'verificationId': verificationId,
          'verificationCode': verificationCode,
        }),
      );

      if (response.statusCode == 200) {
        // Token verified successfully
        return true;
      } else {
        // Error during verification
        print('Verification failed: ${response.body}');
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }
}
