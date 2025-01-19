import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mnm_vendor/widgets/showsnackbar.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../app_colors.dart';

// Define a class to manage the state and logic
class PaymentNotifier extends StateNotifier<List<dynamic>> {
  PaymentNotifier() : super([]);

  // Fetch payment methods
  Future<void> fetchPaymentMethods(String email) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/payment-methods?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      state = jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch payment methods');
    }
  }

  // Add a payment method
  Future<void> addPaymentMethod({
    required String name,
    required String paymentType,
    required String accountNumber,
    required String bankCode,
    required BuildContext ctx,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.get('token');
    final response = await http.post(
      Uri.parse('${AppColors.baseURL}/add-payment-method'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'name': name,
        'type': paymentType,
        "bankCode": bankCode,
        'accountNumber': accountNumber,
      }),
    );

    if (response.statusCode == 200) {
      // await fetchPaymentMethods(''); // Refresh payment methods after adding
      showCustomSnackbar(
          context: ctx, message: jsonDecode(response.body)['message']);
    } else {
      // print(jsonDecode(response.body));
      print(response.body);
      showCustomSnackbar(
          context: ctx, message: jsonDecode(response.body)['message']);
      throw Exception('Failed to add payment method');
    }
  }
}

// Create a provider for the PaymentNotifier
final paymentProvider = StateNotifierProvider<PaymentNotifier, List<dynamic>>(
  (ref) => PaymentNotifier(),
);
