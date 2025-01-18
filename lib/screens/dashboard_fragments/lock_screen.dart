import 'package:flutter/material.dart';
import 'package:mnm_vendor/utils/lock_auth_screen.dart';

import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

class LockScreen extends StatefulWidget {
  final Widget child; // The protected content

  const LockScreen({super.key, required this.child});

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final AuthenticationService _authService = AuthenticationService();
  bool _authenticated = false;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    bool isSupported = await _authService.isDeviceSupported();
    if (!isSupported) {
      _showErrorDialog("Device does not support authentication.", retry: false);
      return;
    }

    bool authenticated = await _authService.authenticateUser(
      "Authenticate to access this page",
    );
    setState(() {
      _authenticated = authenticated;
    });

    if (!authenticated) {
      _showErrorDialog("Authentication failed.", retry: true);
    }
  }

  void _showErrorDialog(String message, {required bool retry}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Authentication Error"),
        content: Text(message),
        actions: [
          if (retry) // Show Retry button only if retry is allowed
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _authenticate(); // Retry authentication
              },
              child: const Text("Retry"),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop();
            }, // Close dialog
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_authenticated) {
      return widget.child; // Show protected content if authenticated
    }

    return const Scaffold(
      body: Center(
        child: NutsActivityIndicator(),
      ),
    );
  }
}
