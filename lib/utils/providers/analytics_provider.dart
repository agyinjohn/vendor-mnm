import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// API URL constant
const String apiUrl = "${AppColors.baseURL}/statistics/";

class StatisticsNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  StatisticsNotifier() : super(const AsyncValue.loading());

  Future<void> fetchStatistics(String week) async {
    try {
      state = const AsyncValue.loading();

      // Fetch the token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        throw Exception("Authorization token not found");
      }

      // Configure headers
      final headers = {
        "Authorization": "Bearer $token",
      };

      // Make the GET request
      final response = await http
          .get(Uri.parse("$apiUrl$week"), headers: headers)
          .timeout(const Duration(seconds: 5));

      // Handle the response
      if (response.statusCode == 200) {
        state = AsyncValue.data(jsonDecode(response.body));
      } else {
        throw Exception("Failed to fetch statistics: ${response.body}");
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Define a provider for the notifier
final statisticsNotifierProvider =
    StateNotifierProvider<StatisticsNotifier, AsyncValue<Map<String, dynamic>>>(
  (ref) => StatisticsNotifier(),
);
