import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mnm_vendor/app_colors.dart';

class OrderService {
  static const String baseUrl =
      AppColors.baseURL; // Replace with your backend URL

  /// Update order status
  static Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required String status,
    required String authToken,
  }) async {
    print(authToken);
    final url = Uri.parse('$baseUrl/order-status');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken', // Pass authentication token
    };
    final body = jsonEncode({
      'orderId': orderId,
      'status': status.toUpperCase(), // Send status as uppercase
    });
// 6731387a867afc1558092c29
// 6731387a867afc1558092c29
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return success response
      } else {
        // Handle error response
        throw Exception(jsonDecode(response.body)['message'] ??
            'Failed to update order status');
      }
    } catch (e) {
      throw Exception('Error updating order status: $e');
    }
  }
}
