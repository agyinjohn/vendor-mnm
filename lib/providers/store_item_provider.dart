import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mnm_vendor/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/store_item.dart';

final storeItemsProvider =
    StateNotifierProvider<StoreItemsNotifier, List<StoreItem>>((ref) {
  return StoreItemsNotifier();
});

class StoreItemsNotifier extends StateNotifier<List<StoreItem>> {
  StoreItemsNotifier() : super([]);

  Future<void> fetchStoreItems(String storeId) async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.get(
        Uri.parse('${AppColors.baseURL}/store-items/$storeId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      // print(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['items'] as List;
        state = jsonData.map((item) => StoreItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load items');
      }
    } catch (error) {
      print(error);
      // Handle error appropriately
    }
  }
}
