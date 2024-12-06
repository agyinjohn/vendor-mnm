// import 'dart:ui';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mnm_vendor/widgets/custom_bottom_sheet.dart';
import '../app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
// import '../widgets/custom_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
    final List<TextEditingController> _controllers =
        List.generate(6, (_) => TextEditingController());

    void _nextField(String value, int index) {
      if (value.length == 1 && index < 5) {
        _focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }
      if (value.length == 1 && index == 5) {
        _focusNodes[index].unfocus();
      }
    }

    final size = MediaQuery.of(context).size;

    bool _isBottomSheetVisible = false;

    void showSuccessSheet(BuildContext context) {
      setState(() {
        _isBottomSheetVisible = true;
      });

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const SuccessSheet(
          title: 'Password Changed Successfully',
          message:
              'You can now use your new password to log in to your account.',
          buttonText: 'Login',
          onTapNavigation: '/signin',
        ),
      ).whenComplete(() {
        setState(() {
          _isBottomSheetVisible = false;
        });
      });

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
            text: const TextSpan(style: TextStyle(fontSize: 12), children: [
          TextSpan(
            text: 'If you did not request this change,\n',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'contact support',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.errorColor),
          ),
          TextSpan(
            text: ' immediately.',
            style: TextStyle(color: Colors.black),
          ),
        ])),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                14.0,
                size.height * 0.22,
                14.00,
                size.height * 0.14,
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.green,
                      height: 100,
                      width: 100,
                      child: Image.asset(
                        'assets/images/main-logo.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Change Password.',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                            textAlign: TextAlign.center,
                            'Kindly enter your new password')),
                    const SizedBox(height: 24),
                    const CustomTextField(
                      isPassword: true,
                      prefixIcon: Icons.lock,
                      hintText: 'Enter your password',
                    ),
                    const SizedBox(height: 14),
                    const CustomTextField(
                      isPassword: true,
                      prefixIcon: Icons.lock,
                      hintText: 'Confirm your password',
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                        onTap: () => showSuccessSheet(context),
                        title: 'Change Password'),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),

          // Blur effect when the bottom sheet is visible
          if (_isBottomSheetVisible)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
        ],
      ),
    );
  }
}
