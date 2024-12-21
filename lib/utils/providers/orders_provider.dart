import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mnm_vendor/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

// OrdersNotifier to fetch raw data
class OrdersNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  OrdersNotifier() : super(const AsyncValue.loading());

  Future<void> fetchOrders() async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final String? token = sharedPreferences.getString('token');
      const String url = '${AppColors.url}/vendor/orders';
      // Replace with your token
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        state = AsyncValue.data(data);
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}

// Create a provider for orders
final ordersProvider =
    StateNotifierProvider<OrdersNotifier, AsyncValue<Map<String, dynamic>>>(
        (ref) {
  return OrdersNotifier();
});

class RecentOrdersNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  RecentOrdersNotifier() : super(const AsyncValue.loading());

  Future<void> fetchRecentOrders() async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final String? token = sharedPreferences.getString('token');
      const String url = '${AppColors.url}/vendor/recent/orders';
      // Replace with your token
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 30));
      print(jsonDecode(response.body));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        state = AsyncValue.data(data);
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (error) {
      print(error);
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}

// Create a provider for orders
final recentOrdersProvider =
    StateNotifierProvider<RecentOrdersNotifier, AsyncValue<List<dynamic>>>(
        (ref) {
  return RecentOrdersNotifier();
});
