import 'package:flutter/material.dart';

import 'package:mnm_vendor/app_colors.dart';
import 'package:mnm_vendor/screens/sign_up_screen.dart';
import 'package:mnm_vendor/widgets/custom_button.dart';

import '../utils/onboarding_items.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  static const routeName = '/onboarding-screen';
  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(height: size.height * 0.026),
                    _buildHeader(size),
                    _buildImageSection(size, index),
                  ],
                );
              },
            ),
            _buildBottomSection(size),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.08,
        vertical: size.height * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: size.height * 0.05,
            width: size.width * 0.35,
            child: Image.asset(
              'assets/images/logo.jpg',
              fit: BoxFit.fill,
            ),
          ),
          if (_currentPage < onboardingData.length - 1)
            TextButton(
              onPressed: () {
                _pageController.jumpToPage(onboardingData.length - 1);
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  color: AppColors.titleColor.withOpacity(0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageSection(Size size, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.07,
        vertical: size.height * 0.02,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(size.width * 0.05)),
        child: Image.asset(
          onboardingData[index].imagePath,
          height: size.height * 0.4,
          width: size.width * 0.8,
        ),
      ),
    );
  }

  Widget _buildBottomSection(Size size) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: size.height * 0.35,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size.width * 0.09),
            topRight: Radius.circular(size.width * 0.09),
          ),
          image: DecorationImage(
            image: const AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.3),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.07),
          child: Column(
            children: [
              Text(
                onboardingData[_currentPage].title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.w900,
                  color: AppColors.titleColor,
                ),
              ),
              SizedBox(height: size.height * 0.015),
              Text(
                onboardingData[_currentPage].description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.035,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              _buildDotsIndicator(size),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: _buildNavigationButtons(size),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDotsIndicator(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingData.length,
        (index) => _buildDot(size, index),
      ),
    );
  }

  Widget _buildNavigationButtons(Size size) {
    if (_currentPage == onboardingData.length - 1) {
      return SizedBox(
        width: size.width * 0.8,
        child: CustomButton(
          onTap: (() => Navigator.pushNamed(context, SignUpScreen.routeName)),
          title: 'Get Started',
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _currentPage == 0
              ? null
              : () {
                  setState(() {
                    _currentPage--;
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
                },
          child: Text(
            'Back',
            style: _currentPage == 0
                ? TextStyle(
                    fontSize: size.width * 0.04, color: Colors.transparent)
                : TextStyle(fontSize: size.width * 0.04, color: Colors.black),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _currentPage++;
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
          child: Container(
            height: size.height * 0.07,
            padding: EdgeInsets.all(size.width * 0.03),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.width * 0.025),
              color: AppColors.primaryColor,
            ),
            child: Center(
              child: Row(
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      color: AppColors.onPrimaryColor,
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  const Icon(Icons.arrow_forward_outlined,
                      color: AppColors.onPrimaryColor),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDot(Size size, int index) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: size.width * 0.01), // Dynamic margin
      width: _currentPage == index
          ? size.width * 0.09
          : size.width * 0.045, // Dynamic width
      height: size.height * 0.02, // Dynamic height
      decoration: BoxDecoration(
        borderRadius: _currentPage == index
            ? BorderRadius.circular(size.width * 0.02)
            : null,
        shape: _currentPage == index ? BoxShape.rectangle : BoxShape.circle,
        color: _currentPage == index
            ? AppColors.primaryColor
            : Colors.black.withOpacity(0.7),
      ),
    );
  }
}
