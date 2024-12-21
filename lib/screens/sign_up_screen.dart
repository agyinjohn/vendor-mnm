import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mnm_vendor/screens/otp_screen.dart';
import 'package:mnm_vendor/screens/sign_in_screen.dart';
import 'package:mnm_vendor/utils/authentication.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:page_transition/page_transition.dart';
import '../app_colors.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'package:iconly/iconly.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const routeName = '/sign-up-page';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Key for the form
  bool _isLoading = false;

  // Reference to the ApiService
  final Authentication _authentication = Authentication();

  // Signup function with error handling and password confirmation
  Future<void> _signup() async {
    // Validate form fields
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Call the signup API
      String? result = await _authentication.signup(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          role: 'vendor',
          phoneNumber: _phoneController.text.trim(),
          name: _nameController.text.trim());
      if (result == 'Signup Successful') {
        setState(() {
          _isBottomSheetVisible = true;
        });
        showSuccessSheet(context);
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.push(
              context,
              PageTransition(
                  child: const OTPScreen(),
                  type: PageTransitionType.rightToLeft));
        });
        _emailController.text = '';
        _passwordController.text = '';
        _confirmPasswordController.text = '';
        _phoneController.text = '';
        _nameController.text = '';
      }
      // Show result message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? 'Unknown error')),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  final List<Image> accounts = [
    Image.asset('assets/images/g.png'),
    Image.asset('assets/images/a.png'),
    Image.asset('assets/images/f.png'),
  ];

  // Dispose controllers when not in use
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _isBottomSheetVisible = false;

  // Function to show success bottom sheet
  void showSuccessSheet(BuildContext context) {
    setState(() {
      _isBottomSheetVisible = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessSheet(
        title: 'Account successfully created!',
        message:
            'Welcome to M&M Delivery App!\nStart exploring all the features we have to offer.',
        buttonText: 'Continue',
        onTapNavigation: '/verify1',
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

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  14.0,
                  size.height * 0.03,
                  14.0,
                  size.height * 0.02,
                ),
                child: Center(
                  child: Form(
                    // Wrap with Form
                    key: _formKey, // Attach the form key
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 100,
                          child: Image.asset(
                            'assets/images/main-logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create an account.',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          textAlign: TextAlign.center,
                          'Please fill in the details below to create your account.',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          children: [
                            Text(
                              'Account Information ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('*',
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _nameController,
                          isPassword: false,
                          prefixIcon: IconlyBroken.profile,
                          hintText: 'Enter your full name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name cannot be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextField(
                          controller: _emailController,
                          isPassword: false,
                          prefixIcon: IconlyBroken.message,
                          hintText: 'Enter your email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email cannot be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextField(
                          controller: _phoneController,
                          isPassword: false,
                          prefixIcon: IconlyBroken.call,
                          hintText: 'Enter your phone number',
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 10) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextField(
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: IconlyBroken.lock,
                          hintText: 'Enter your password',
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextField(
                          controller: _confirmPasswordController,
                          isPassword: true,
                          prefixIcon: IconlyBroken.lock,
                          hintText: 'Confirm your password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm password cannot be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          onTap: _signup,
                          title: 'Sign Up',
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Or continue with',
                          style: TextStyle(fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: accounts.map((image) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: image,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, SignInScreen.routeName),
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
            ),
          ),
          if (_isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white70,
              child: Center(
                child: Container(
                  height: 50,
                  width: 50,
                  color: Colors.transparent,
                  child: const NutsActivityIndicator(),
                ),
              ),
            ),
          // Blurred background when bottom sheet is visible
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
