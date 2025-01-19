import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mnm_vendor/app_colors.dart';
import 'package:mnm_vendor/models/user_model.dart';
import 'package:mnm_vendor/screens/dashboard_page.dart';
import 'package:mnm_vendor/utils/providers/user_provider.dart';
import 'package:mnm_vendor/utils/store_notifier.dart';
import 'package:mnm_vendor/widgets/showsnackbar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/dashboard_fragments/verification_page.dart';

// State class to manage loading, error, and success states
class AuthState {
  final bool isLoading;
  final String? error;
  final bool loggedIn;

  AuthState({this.isLoading = false, this.error, this.loggedIn = false});

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? loggedIn,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      loggedIn: loggedIn ?? this.loggedIn,
    );
  }
}

// State Notifier for Authentication
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<bool> login(
      String id, String password, BuildContext context, WidgetRef ref) async {
    state = state.copyWith(isLoading: true, error: null);

    final url = Uri.parse('${AppColors.baseUrl}/login');
    print(url);
    try {
      final response = await http
          .post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'password': password,
        }),
      )
          .timeout(
        const Duration(seconds: 100),
        onTimeout: () {
          throw TimeoutException(
              'The connection has timed out, please try again');
        },
      );

      if (response.statusCode == 200) {
        // Parse the response
        final data = jsonDecode(response.body);
        String token = data['token'];
        Map<String, dynamic> user = data['user'];

        // Save the token and user data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        String? role = decodedToken['role'];

        // Check if the user is a vendor
        if (role != 'vendor') {
          // Show an error message if the role is not vendor
          state = state.copyWith(
            isLoading: false,
            error: 'Access denied. Vendor role required.',
          );
          showCustomSnackbar(
              context: context,
              message: 'Access denied. Vendor role required.');
          return false;
        }
        await prefs.setString('token', token);

        User userData = User(
            id: user['_id'],
            name: user['name'],
            email: user['email'],
            phoneNumber: user['phoneNumber'],
            role: user['role']);
        // ref.read(userProvider.notifier).saveUser(userData);
        print(userData.email);
        if (!context.mounted) return false;
        // Update state to indicate login success
        state = state.copyWith(isLoading: false, loggedIn: true);

        await ref.read(storeProvider.notifier).fetchStores(token, context);
        final stores = ref.read(storeProvider);
        if (stores.isEmpty) {
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              child: const KycVerificationScreen(),
              type: PageTransitionType.bottomToTop,
              duration: const Duration(milliseconds: 1000),
            ),
            (route) => false,
          );
          return true;
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
              (route) => false);
          return true;
        }
      } else if (response.statusCode == 400) {
        // Handle bad request errors
        final errorData = jsonDecode(response.body);
        print(errorData);
        state = state.copyWith(
          isLoading: false,
          error: errorData['message'],
        );
        return false;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Unexpected status code ${response.statusCode}',
        );
        return false;
      }
    } on TimeoutException catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'The connection has timed out, please try again',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error during login: $e',
      );
      print(e);
      return false;
    }
    // finally {
    //   state = state.copyWith(
    //     isLoading: false,
    //     error: 'Error during login: ',
    //   );
    // }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
