import 'package:flutter/material.dart';
import 'package:mnm_vendor/app_colors.dart';

class SuccessSheet extends StatelessWidget {
  final String title, message, buttonText, onTapNavigation;

  const SuccessSheet(
      {super.key,
      required this.title,
      required this.message,
      required this.buttonText,
      required this.onTapNavigation});

  @override
  Widget build(BuildContext context) {
    // Calculate 40% of the screen height
    final double screenHeight = MediaQuery.of(context).size.height;
    final double sheetHeight = screenHeight * 0.40;

    return Container(
      height: sheetHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 4,
              ),
              color: Colors.transparent,
            ),
            child: const Icon(
              Icons.check,
              size: 40,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

void showAccountCreationSuccessSheet(BuildContext context, String title,
    String message, String buttonText, String onTapNavigation) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => SuccessSheet(
      title: title,
      message: message,
      buttonText: buttonText,
      onTapNavigation: onTapNavigation,
    ),
  );
}
