import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mnm_vendor/app_colors.dart';
import 'package:mnm_vendor/widgets/showsnackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> uploadFastFoodItems(
    Map<String, dynamic> itemData, BuildContext context) async {
  final url = Uri.parse('${AppColors.baseURL}/item');
  try {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    final token = pref.getString('token');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token' // Optional if auth is needed
      },
      body: jsonEncode(itemData),
    );

    if (response.statusCode == 200) {
      showCustomSnackbar(
          context: context, message: 'Food uploaded successfully');
    } else {
      print(response.body);
      showCustomSnackbar(
          context: context,
          message: jsonDecode(response.body)['message'],
          duration: const Duration(seconds: 30));
    }
  } catch (e) {
    print(e.toString());
    showCustomSnackbar(context: context, message: e.toString());
  }
}

Future<void> uploadOtherCategoryItems(
    Map<String, dynamic> itemData, String storeId, String category) async {
  final url =
      Uri.parse('https://your-backend-url.com/$category/upload/$storeId');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' // Optional if auth is needed
      },
      body: jsonEncode(itemData),
    );

    if (response.statusCode == 200) {
      print("Item for $category uploaded successfully.");
    } else {
      print("Failed to upload item for $category: ${response.body}");
    }
  } catch (e) {
    print("Error uploading item for $category: $e");
  }
}
