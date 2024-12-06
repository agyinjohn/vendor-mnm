import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mnm_vendor/widgets/custom_bottom_sheet.dart';
import '../app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
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
        builder: (context) => SuccessSheet(
          title: 'Email Verified Successfully',
          message:
              'An OPT (One-Time Password) has been sent to your regiestered email address/phone number.',
          buttonText: 'Continue',
          onTapNavigation: '/otp',
        ),
      ).whenComplete(() {
        setState(() {
          _isBottomSheetVisible = false;
        });
      });
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
                size.height * 0.16,
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
                      'Forgot Password?',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                            style: TextStyle(
                              // fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'No worries! Enter your ',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: 'email/phone number ',
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                              TextSpan(
                                text:
                                    'below and we\'ll help you reset \nyour password.',
                                style: TextStyle(color: Colors.black),
                              )
                            ]),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const CustomTextField(
                      isPassword: false,
                      prefixIcon: Icons.mail,
                      hintText: 'Enter your email or phone number',
                    ),
                    const SizedBox(height: 22),
                    CustomButton(
                        onTap: () => showSuccessSheet(context),
                        title: 'Confirm Email'),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Remembered password?',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/signin'),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
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
