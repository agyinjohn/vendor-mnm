// <<<<<<< HEAD
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mnm_vendor/app_colors.dart';

import '../widgets/custom_bottom_sheet.dart';
import '../widgets/custom_button.dart';

class VerifyIdentityScreen3 extends StatefulWidget {
  const VerifyIdentityScreen3({super.key});

  @override
  State<VerifyIdentityScreen3> createState() => _VerifyIdentityScreen3State();
}

class _VerifyIdentityScreen3State extends State<VerifyIdentityScreen3> {
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
        title: 'Continue to Dashboard',
        message:
            'Your account will be verified soon.\nYou can start uploading your products.',
        buttonText: 'Continue',
        onTapNavigation: '/dashboard',
      ),
    ).whenComplete(() {
      setState(() {
        _isBottomSheetVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.width * 0.035,
                horizontal: size.height * 0.02,
                // size.width * 0.035,
                // size.height * 0.02,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius:
                              BorderRadius.circular(size.width * 0.05),
                        ),
                        height: size.height * 0.008,
                        width: size.width * 0.27,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius:
                              BorderRadius.circular(size.width * 0.05),
                        ),
                        height: size.height * 0.008,
                        width: size.width * 0.27,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius:
                              BorderRadius.circular(size.width * 0.05),
                        ),
                        height: size.height * 0.008,
                        width: size.width * 0.27,
                      ),
                      const Text('3/3'),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: size.height * 0.02,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(size.width * 0.05),
                      ),
                      child: Image.asset(
                        'assets/images/ID-Card.png',
                        height: size.height * 0.32,
                        width: size.width * 0.64,
                      ),
                    ),
                  ),
                  Text(
                    'Let\'s verify your identity',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.06,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.12),
                    child: Text(
                      textAlign: TextAlign.center,
                      'Please upload these documents to verify your account',
                      style: TextStyle(
                        fontSize: size.width * 0.034,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  _card(
                    context,
                    const Icon(IconlyBroken.image),
                    'Take a picture of your valid ID',
                    'To check your personal information is correct.',
                  ),
                  _card(
                    context,
                    const Icon(IconlyBroken.camera),
                    'Take a selfie of yourself',
                    'To match your face on your identification card',
                  ),
                  _card(
                    context,
                    const Icon(IconlyBroken.camera),
                    'Enter your business info',
                    'For data keeping\n',
                  ),
                  SizedBox(height: size.height * 0.008),
                  GestureDetector(
                    onTap: () => showSuccessSheet(context),
                    child: Container(
                      height: size.height * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppColors.primaryColor,
                      ),
                      child: const Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.onPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ), // Blur effect when the bottom sheet is visible
        if (_isBottomSheetVisible)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
      ],
    );
  }

  Widget _card(
    BuildContext context,
    Icon cardIcon,
    String title,
    String subTitle,
    // BuildContext context
  ) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.004),
      child: SizedBox(
        child: Card(
          elevation: 2,
          color: AppColors.cardColor,
          child: Padding(
            padding: EdgeInsets.all(size.height * 0.014),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cardIcon,
                      SizedBox(width: size.width * 0.014),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.038,
                              ),
                            ),
                            SizedBox(height: size.height * 0.003),
                            Text(
                              subTitle,
                              style: TextStyle(
                                fontSize: size.width * 0.028,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: CircleAvatar(
                    radius: size.width * 0.03,
                    backgroundColor: Colors.green[400],
                    child: Icon(
                      size: size.width * 0.045,
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
