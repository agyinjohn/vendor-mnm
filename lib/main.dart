import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mnm_vendor/screens/on_boarding_screen.dart';
import 'package:mnm_vendor/screens/sign_in_screen.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'screens/dashboard_page.dart';
import 'utils/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool isLoading = true;
  bool isVendor = false;
  bool hasToken = false; // Flag to track token presence
  Timer? _tokenCheckTimer; // Timer for periodic token check

  @override
  void initState() {
    super.initState();
    checkUserRole();
    startTokenExpirationListener(); // Start the token expiration listener
  }

  @override
  void dispose() {
    _tokenCheckTimer?.cancel(); // Cancel the timer when widget is disposed
    super.dispose();
  }

  Future<void> checkUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      hasToken = true; // Token exists
      if (!JwtDecoder.isExpired(token)) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if (decodedToken['role'] == 'vendor') {
          setState(() {
            isVendor = true; // User is a vendor
          });
        }
      }
    }

    setState(() {
      isLoading = false; // Set loading to false after validation
    });
  }

  void startTokenExpirationListener() {
    _tokenCheckTimer =
        Timer.periodic(const Duration(seconds: 30), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || JwtDecoder.isExpired(token)) {
        // If the token is expired or doesn't exist, log out the user
        await prefs.remove('token'); // Clear token from storage
        setState(() {
          hasToken = false;
          isVendor = false;
        });
        timer.cancel(); // Stop the timer after token expiration
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'M&M Delivery Services',
      home: isLoading
          ? const Scaffold(
              body: Center(
                child: NutsActivityIndicator(),
              ),
            )
          : !hasToken
              ? const OnboardingScreen() // Go to OnboardingScreen if no token is found
              : isVendor
                  ? const DashboardPage() // Go to DashboardPage if user is a vendor
                  : const SignInScreen(), // Go to SignInScreen for other cases
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade800),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => onGenerateRoute(settings, ref),
    );
  }
}
