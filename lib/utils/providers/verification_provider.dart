import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mnm_vendor/app_colors.dart';
import 'package:mnm_vendor/utils/providers/verification_provider_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorVerificationNotifier
    extends StateNotifier<VendorVerificationState> {
  VendorVerificationNotifier() : super(VendorVerificationState());

  Future<void> fetchVerificationStatus() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final localToken = pref.getString('token');
    const String url = "${AppColors.baseURL}/verification-status";
    String token = "Bearer $localToken";

    try {
      state = state.copyWith(isLoading: true);

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": token,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        print(data);
        state = state.copyWith(
          hasStore: data['hasStore'],
          verified: data['verified'],
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to fetch verification status. Please try again.",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
