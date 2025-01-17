import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mnm_vendor/screens/dashboard_fragments/products_thread/upload_food_screen.dart';
import 'package:mnm_vendor/screens/sign_up_screen.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import '../app_colors.dart';
import '../utils/providers/login_auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'dashboard_fragments/products_thread/upload_beverage_screen.dart';
import 'dashboard_fragments/products_thread/upload_drug_page.dart';
import 'dashboard_fragments/products_thread/upload_food_screen.dart';
import 'dashboard_fragments/products_thread/upload_gift_screen.dart';
// import 'dashboard_fragments/products_thread/upload_drug_page.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});
  static const routeName = '/sign-in-screen';
  @override
  ConsumerState<SignInScreen> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInScreen> {
  final TextEditingController _controllerID = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _showError = false;
  @override
  void dispose() {
    super.dispose();
    _controllerID.dispose();
    _controllerPassword.dispose();
  }

  final List<Image> accounts = [
    Image.asset('assets/images/g.png'),
    Image.asset('assets/images/a.png'),
    Image.asset('assets/images/f.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    if (authState.error != null && !_showError) {
      setState(() {
        _showError = true;
      });
      Timer(const Duration(seconds: 10), () {
        setState(() {
          _showError = false;
        });
        authNotifier
            .clearError(); // Assuming there's a method to clear the error
      });
    }

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              _showError &&
                      authState.error != null &&
                      authState.error!.isNotEmpty
                  ? AnimatedPositioned(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      top: _showError
                          ? size.height * 0.05
                          : size.height, // Move down and up
                      left: 20,
                      right: 20,
                      child: Container(
                        width: size.width * 0.5,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5)),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              softWrap: true,
                              authState.error ?? '',
                              maxLines: null,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                        // color: Colors.red,
                      ),
                    )
                  : Container(
                      width: 0,
                    ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  14.0,
                  size.height * 0.10,
                  14.00,
                  size.height * 0.06,
                ),
                child: SingleChildScrollView(
                  child: Column(
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
                        'Welcome back!',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Kindly enter your details to login.',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _controllerID,
                        isPassword: false,
                        prefixIcon: Icons.mail,
                        hintText: 'Enter your email or phone number',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: _controllerPassword,
                        isPassword: true,
                        prefixIcon: Icons.lock,
                        hintText: 'Enter your password here',
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot_passoword');
                          },
                          child: const Text(
                            'Forgot your password?',
                            style: TextStyle(
                              color: Colors.orange,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UploadFoodScreen())),
                          // onTap: () async {
                          //   final isloginSuccess = await authNotifier.login(
                          //       _controllerID.text.trim(),
                          //       _controllerPassword.text.trim(),
                          //       context,
                          //       ref);
                          // },
                          title: 'Login'),
                      const SizedBox(height: 24),
                      const Text(
                        'Or continue with',
                        style: TextStyle(fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
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
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(
                                context, SignUpScreen.routeName),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.orange,
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
              authState.isLoading
                  ? Container(
                      height: size.height,
                      width: size.width,
                      decoration: const BoxDecoration(color: Colors.white70),
                      child: Center(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          width: 50,
                          child: const Center(
                            child: NutsActivityIndicator(
                              radius: 10,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: 0,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
