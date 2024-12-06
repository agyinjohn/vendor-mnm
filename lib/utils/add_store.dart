import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/app_colors.dart';

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
    required String type,
    required WidgetRef ref,
  }) async {
    // API endpoint for adding the store
    const String apiUrl = '${AppColors.url}/vendor/add-store-info';

    // Create the body for the POST request
    Map<String, dynamic> storeData = {
      'storeName': storeName,
      'latitude': latitude,
      'longitude': longitude,
      'storePhone': storePhone,
      'storeAddress': storeAddress,
      'type': type,
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
      print(response.body);
      if (response.statusCode == 200) {
        // Success: Update the response provider
        ref.read(storeResponseProvider.notifier).state =
            'Store successfully added';
      } else if (response.statusCode == 400) {
        // Handle bad request
        ref.read(storeResponseProvider.notifier).state = 'Not all fields given';
      } else if (response.statusCode == 401) {
        // Handle unauthorized (identity not verified)
        ref.read(storeResponseProvider.notifier).state =
            'Vendor identity not verified';
      } else {
        // Handle unexpected error
        ref.read(storeResponseProvider.notifier).state =
            'Error adding store info';
      }
    } catch (error) {
      // Handle network or server error
      ref.read(storeResponseProvider.notifier).state = 'Network error';
      print('Error: $error');
    }
  }
}
