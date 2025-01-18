import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../../app_colors.dart';

class EarningsSummary {
  final double totalEarnings;
  final double dailyEarnings;
  final double weeklyEarnings;
  final double pendingPayouts;
  final List<Gearn> groupedEarnings;
  final List<OrderDetail> orders;

  EarningsSummary({
    required this.totalEarnings,
    required this.dailyEarnings,
    required this.weeklyEarnings,
    required this.pendingPayouts,
    required this.groupedEarnings,
    required this.orders,
  });

  factory EarningsSummary.fromJson(Map<String, dynamic> json) {
    return EarningsSummary(
      totalEarnings: json['totalEarnings'].toDouble(),
      dailyEarnings: json['dailyEarnings'].toDouble(),
      weeklyEarnings: json['weeklyEarnings'].toDouble(),
      pendingPayouts: json['pendingPayouts'].toDouble(),
      groupedEarnings: (json['groupedEarnings'] as List)
          .map((e) => Gearn.fromJson(e))
          .toList(),
      orders:
          (json['orders'] as List).map((e) => OrderDetail.fromJson(e)).toList(),
    );
  }
}

class OrderDetail {
  final String date;
  final String orderId;
  final double amount;

  OrderDetail({
    required this.date,
    required this.orderId,
    required this.amount,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      date: json['date'],
      orderId: json['orderId'],
      amount: json['amount'].toDouble(),
    );
  }
}

class Gearn {
  final String date;

  final double amount;

  Gearn({
    required this.date,
    required this.amount,
  });

  factory Gearn.fromJson(Map<String, dynamic> json) {
    return Gearn(
      date: json['date'],
      amount: json['amount'].toDouble(),
    );
  }
}

class EarningsSummaryNotifier extends AsyncNotifier<EarningsSummary> {
  Future<void> fetchEarnings(Map<String, String> queryParams) async {
    const baseUrl = '${AppColors.baseURL}/earnings/summary';

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      if (token == null) throw Exception('Token missing, please log in.');

      state = const AsyncValue.loading();
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = AsyncValue.data(EarningsSummary.fromJson(data));
      } else {
        throw Exception('Failed to fetch earnings summary: ${response.body}');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  @override
  FutureOr<EarningsSummary> build() {
    return EarningsSummary(
      totalEarnings: 0.0,
      dailyEarnings: 0.0,
      weeklyEarnings: 0.0,
      pendingPayouts: 0.0,
      groupedEarnings: [],
      orders: [],
    );
  }
}

final earningsSummaryProvider =
    AsyncNotifierProvider<EarningsSummaryNotifier, EarningsSummary>(
  () => EarningsSummaryNotifier(),
);
