import 'dart:convert'; // For base64 encoding
import 'dart:io'; // For File operations
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:mnm_vendor/app_colors.dart';

import 'package:path_provider/path_provider.dart'; // To get the temp directory for saving files

Future<void> uploadIdentityVerification({
  required File idCardFile,
  required File userPicFile,
  required String token, // Auth token for the request
}) async {
  try {
    // Convert image files to Base64 strings
    String idCardBase64 = base64Encode(await idCardFile.readAsBytes());
    String userPicBase64 = base64Encode(await userPicFile.readAsBytes());

    // Create the request body
    Map<String, dynamic> requestBody = {
      "idCard": {
        "data": "base64,$idCardBase64",
        "fileName": idCardFile.path.split("/").last, // Extract the file name
      },
      "userPic": {
        "data": "base64,$userPicBase64",
        "fileName": userPicFile.path.split("/").last, // Extract the file name
      }
    };

    // Make the HTTP POST request
    final response = await http.post(
      Uri.parse(
          '${AppColors.baseURL}/store-verification'), // Replace with your endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Assuming JWT token for authorization
      },
      body: jsonEncode(requestBody),
    );
    print(response);
    // Handle the response
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("Success: ${responseData['message']}");
      // You can display a success message here
    } else {
      print("Error: ${response.body}");
      // Handle error response
    }
  } catch (e) {
    print("An error occurred: $e");
    // Handle any errors in the request
  }
}
