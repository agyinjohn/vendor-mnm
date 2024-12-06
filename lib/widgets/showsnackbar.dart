import 'package:flutter/material.dart';

// Reusable function to show a customized Snackbar
void showCustomSnackbar({
  required BuildContext context,
  required String message,
  Color backgroundColor = Colors.black,
  SnackBarAction? action,
  Duration duration = const Duration(seconds: 3),
}) {
  // Create the snackbar
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white), // Text style customization
    ),
    backgroundColor: backgroundColor, // Customize background color
    action: action, // Optional action
    duration: duration, // Duration for how long the snackbar will be shown
    behavior: SnackBarBehavior.floating, // This makes the snackbar float
    shape: RoundedRectangleBorder(
      // Rounded corners
      borderRadius: BorderRadius.circular(12),
    ),
    margin:
        const EdgeInsets.all(16), // Margin to create space around the snackbar
  );

  // Show the snackbar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
