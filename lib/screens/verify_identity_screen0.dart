import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mnm_vendor/app_colors.dart';

import 'verify_identity_screen1.dart';

class VerifyIdentityScreen0 extends StatelessWidget {
  const VerifyIdentityScreen0({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
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
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(size.width * 0.05),
                    ),
                    height: size.height * 0.008,
                    width: size.width * 0.27,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(size.width * 0.05),
                    ),
                    height: size.height * 0.008,
                    width: size.width * 0.27,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(size.width * 0.05),
                    ),
                    height: size.height * 0.008,
                    width: size.width * 0.27,
                  ),
                  const Text('0/3'),
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
              // SizedBox(height: size.height * 0.004),
              Text(
                'Let\'s verify your identity',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.06,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.12),
                child: Text(
                  textAlign: TextAlign.center,
                  'Please upload these documents to verify your account',
                  style: TextStyle(
                    // fontWeight: FontWeight.w400,
                    fontSize: size.width * 0.034,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VerifyIdentityScreen1()));
                },
                child: _card(
                  context,
                  const Icon(IconlyBroken.image),
                  'Take a picture of your valid ID',
                  'To check your personal information is correct.',
                ),
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
              SizedBox(height: size.height * 0.02),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'Why is this needed?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.034,
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryColor,
                    ),
                  ))
            ],
          ),
        ),
      ),
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
                  child: const Icon(IconlyLight.arrow_right_2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
