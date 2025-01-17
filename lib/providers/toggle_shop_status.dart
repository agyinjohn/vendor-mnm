import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mnm_vendor/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreStatus {
  final String storeId;
  final String status;

  StoreStatus({required this.storeId, required this.status});

  factory StoreStatus.fromJson(Map<String, dynamic> json) {
    return StoreStatus(
      storeId: json['storeId'],
      status: json['status'],
    );
  }
}

class StoreStatusNotifier extends AsyncNotifier<StoreStatus?> {
  Future<void> fetchStoreStatus(String storeId) async {
    const baseUrl = '${AppColors.baseURL}/store-state';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Token is missing. Please log in.');

      state = const AsyncValue.loading();

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'storeId': storeId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final storeStatus = StoreStatus(
          storeId: storeId,
          status: data['status'],
        );
        state = AsyncValue.data(storeStatus);
      } else {
        throw Exception('Failed to fetch store status: ${response.body}');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleStoreStatus(String storeId, String newState) async {
    const baseUrl = '${AppColors.baseURL}/store-state';
    final previousState = state;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Token is missing. Please log in.');

      state = const AsyncValue.loading();

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'storeId': storeId,
          'state': newState,
        }),
      );

      if (response.statusCode == 200) {
        // Update local state
        final updatedStatus = StoreStatus(storeId: storeId, status: newState);
        state = AsyncValue.data(updatedStatus);
      } else {
        throw Exception('Failed to update store status: ${response.body}');
      }
    } catch (e, stack) {
      state = previousState;
      state = AsyncValue.error(e, stack);
    }
  }

  @override
  FutureOr<StoreStatus?> build() async {
    try {
      // Get SharedPreferences instance
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Fetch token from SharedPreferences
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception('Authentication token is missing. Please log in.');
      }

      // Fetch storeId from SharedPreferences
      final storeId = prefs.getString('selectedStoreId');
      print(storeId);
      if (storeId == null) {
        throw Exception('Store ID is not set. Please select a store.');
      }

      // Make API request to fetch store status
      final response = await http.post(
        Uri.parse('${AppColors.baseURL}/store-state'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'storeId': storeId}),
      );

      // Handle response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StoreStatus.fromJson(data);
      } else {
        throw Exception('Failed to fetch store status: ${response.body}');
      }
    } catch (e, stack) {
      // Log error and set state to error
      print('Error in build: $e');
      state = AsyncValue.error(e, stack);
    }
    return null;
  }
}

final storeStatusProvider =
    AsyncNotifierProvider<StoreStatusNotifier, StoreStatus?>(
  () => StoreStatusNotifier(),
);
