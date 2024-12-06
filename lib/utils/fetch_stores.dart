import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mnm_vendor/app_colors.dart';
import 'package:mnm_vendor/widgets/showsnackbar.dart';
import 'dart:convert';

import '../models/store.dart';

Future<List<Store>> fetchStoresFromApi(
    String token, BuildContext context) async {
  final response = await http.get(
    Uri.parse('${AppColors.baseURL}/stores'), // Replace with your API endpoint
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    print(data);
    return data.map((storeJson) => Store.fromJson(storeJson)).toList();
  } else {
    print(response.body);
    showCustomSnackbar(context: context, message: 'Failed to load stores');
    throw Exception('Failed to load stores');
  }
}
