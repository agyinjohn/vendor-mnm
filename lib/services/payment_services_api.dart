import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mnm_vendor/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/payment_model.dart';
// Ensure this file has the PaymentMethod model.
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentMethodsProvider = FutureProvider<List<PaymentMethod>>((ref) async {
  // Use your actual token
  return await PaymentService.fetchPaymentMethods();
});

class PaymentService {
  static const String baseUrl = AppColors.baseURL;

  static Future<List<PaymentMethod>> fetchPaymentMethods() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('$baseUrl/payment-methods');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PaymentMethod.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load payment methods");
    }
  }
}
