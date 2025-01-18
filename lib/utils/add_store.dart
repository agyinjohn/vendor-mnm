import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/app_colors.dart';
import 'package:mnm_vendor/widgets/showsnackbar.dart';

import '../screens/dashboard_fragments/verification_page.dart';

// Define the provider for the API response
final storeResponseProvider = StateProvider<String?>((ref) => null);

class StoreService {
  static Future<void> addStore({
    required String token,
    required String storeName,
    required double latitude,
    required String storeAddress,
    required double longitude,
    required String storePhone,
    required String startTime,
    required String endTime,
    required String type,
    required WidgetRef ref,
    required List<Map<String, String>> images,
    required BuildContext contxt,
    required VoidCallback onComplete,
  }) async {
    // API endpoint for adding the store
    const String apiUrl = '${AppColors.url}/vendor/add-store-info';

    // Create the body for the POST request
    Map<String, dynamic> storeData = {
      'storeName': storeName,
      'startTime': startTime,
      'endTime': endTime,
      'latitude': latitude,
      'longitude': longitude,
      'storePhone': storePhone,
      'storeAddress': storeAddress,
      'type': type,
      'images': images,
    };

    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(storeData),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        // Success: Update the response provider
        onComplete();
        showCustomSnackbar(
            context: contxt, message: 'store successfully added');
        Navigator.pushReplacementNamed(contxt, KycVerificationScreen.routeName);
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (error) {
      // Handle network or server error
      showCustomSnackbar(context: contxt, message: '$error');
    }
  }
}
