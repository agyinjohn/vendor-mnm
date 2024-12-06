import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mnm_vendor/app_colors.dart';

Future<void> updateFCMTokenInBackend(String token, userToken) async {
  final response = await http.post(
    Uri.parse('${AppColors.url}/auth/updatefcmtoken'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    },
    body: jsonEncode(<String, String>{
      'fcmToken': token,
    }),
  );

  if (response.statusCode == 200) {
    print("FCM Token updated successfully.");
  } else {
    print("Failed to update FCM token.");
  }
}
