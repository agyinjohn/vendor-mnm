import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mnm_vendor/app_colors.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/authentication.dart';
import '../../widgets/custom_bottom_sheet.dart';
// import '../../widgets/custom_button.dart';
import 'sign_in_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final Authentication _authentication = Authentication();
  String? verificationId = '';
  bool _isLoading = false;
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  bool _isBottomSheetVisible = false;

  getVerificationId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      verificationId = sharedPreferences.getString('verificationId');
    });
    print(verificationId);
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      _controllers[i].addListener(() => _handleInput(i));
    }
    getVerificationId();
  }

  Future<void> otpVerification() async {
    String otpCode = _controllers.map((controller) => controller.text).join();
    print(otpCode);
    print(verificationId);

    if (otpCode.length != 6) {
      // Handle error if the OTP is not complete
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the complete 6-digit OTP.')),
      );
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });

      final bool isVerified =
          await _authentication.verifyToken(verificationId!, otpCode);
      if (isVerified) {
        _showSuccessSheet(context);
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.push(
              context,
              PageTransition(
                  child: const SignInScreen(),
                  type: PageTransitionType.rightToLeft));
        });
      } else {
        // Handle OTP verification failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP, please try again.'),
            duration: Duration(seconds: 10),
          ),
        );
      }
    } catch (error) {
      // Handle error during verification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during OTP verification: $error'),
          duration: const Duration(seconds: 10),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handleInput(int index) {
    String value = _controllers[index].text;
    // Move to the next field on input or go back on delete
    if (value.length == 1 && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
    // Handle paste functionality
    if (value.length > 1) {
      _handlePaste(value);
    }
  }

  void _handlePaste(String pastedText) {
    for (int i = 0; i < pastedText.length && i < 6; i++) {
      _controllers[i].text = pastedText[i];
      if (i < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
      }
    }
  }

  void _showSuccessSheet(BuildContext context) {
    setState(() {
      _isBottomSheetVisible = true;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessSheet(
        title: 'OTP Verified Successfully',
        message: 'Your OTP(One Time Password) has been verified successfully.',
        buttonText: 'Continue',
        onTapNavigation: '',
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  14.0,
                  size.height * 0.22,
                  14.0,
                  size.height * 0.14,
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo Container
                      Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/main-logo.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'OTP Verification',
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
                          'Kindly enter the 6 digit code sent to your\nphone number or email.',
                        ),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return Container(
                            width: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              maxLength: 1,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                counterText: '', // Hides the length counter
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              onChanged: (value) {
                                _handleInput(index); // Handle focus movement
                                if (_controllers.every((controller) =>
                                    controller.text.isNotEmpty)) {
                                  otpVerification(); // Automatically verify when all fields are filled
                                }
                              },
                              onSubmitted: (_) => _handleInput(index),
                              inputFormatters: [
                                TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                  // Check if the pasted text is 6 digits long
                                  if (newValue.text.length == 6) {
                                    _handlePaste(newValue.text);
                                  }
                                  return newValue;
                                }),
                              ],
                            ),
                          );
                        }),
                      ),
                      // const SizedBox(height: 28),
                      // const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
            if (_isBottomSheetVisible)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
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
          ],
        ),
      ),
    );
  }
}



//import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mnm_vendor/app_colors.dart';
// // import 'package:flutter/services.dart';

// import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../utils/authentication.dart';
// import '../../widgets/custom_bottom_sheet.dart';
// import '../../widgets/custom_button.dart';
// import 'sign_in_screen.dart';

// class OTPScreen extends StatefulWidget {
//   const OTPScreen({super.key});

//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final Authentication _authentication = Authentication();
//   String? verificationId = '';
//   bool _isLoading = false;
//   final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
//   final List<TextEditingController> _controllers =
//       List.generate(6, (_) => TextEditingController());
//   bool _isBottomSheetVisible = false;

//   getVerificationId() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     setState(() {
//       verificationId = sharedPreferences.getString('verificationId');
//     });
//     print(verificationId);
//   }

//   @override
//   void initState() {
//     super.initState();
//     for (int i = 0; i < 6; i++) {
//       _controllers[i].addListener(() => _handleInput(i));
//     }
//     getVerificationId();
//   }

//   Future<void> otpVerification() async {
//     String otpCode = _controllers.map((controller) => controller.text).join();
//     print(otpCode);
//     print(verificationId);

//     if (otpCode.length != 6) {
//       // Handle error if the OTP is not complete
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter the complete 6-digit OTP.')),
//       );
//       return;
//     }
//     try {
//       setState(() {
//         _isLoading = true;
//       });
//       // Assuming you have a method in your `Authentication` class for verification
//       final bool isVerified =
//           await _authentication.verifyToken(verificationId!, otpCode);
//       if (isVerified) {
//         // OTP Verified successfully, show success sheet
//         _showSuccessSheet(context);
//         Future.delayed(const Duration(seconds: 1), () {
//           Navigator.push(
//               context,
//               PageTransition(
//                   child: const SignInScreen(),
//                   type: PageTransitionType.rightToLeft));
//         });
//       } else {
//         // Handle OTP verification failure
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Invalid OTP, please try again.'),
//             duration: Duration(seconds: 10),
//           ),
//         );
//       }
//     } catch (error) {
//       // Handle error during verification
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error during OTP verification: $error'),
//           duration: const Duration(seconds: 10),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var focusNode in _focusNodes) {
//       focusNode.dispose();
//     }
//     super.dispose();
//   }

//   void _handleInput(int index) {
//     String value = _controllers[index].text;
//     // Move to the next field on input or go back on delete
//     if (value.length == 1 && index < 5) {
//       FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
//     } else if (value.isEmpty && index > 0) {
//       FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
//     }
//     // Handle paste functionality
//     if (value.length > 1) {
//       _handlePaste(value);
//     }
//   }

//   void _handlePaste(String pastedText) {
//     for (int i = 0; i < pastedText.length && i < 6; i++) {
//       _controllers[i].text = pastedText[i];
//       if (i < 5) {
//         FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
//       }
//     }
//   }

//   void _showSuccessSheet(BuildContext context) {
//     setState(() {
//       _isBottomSheetVisible = true;
//     });
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => const SuccessSheet(
//         title: 'OTP Verified Successfully',
//         message: 'Your OTP(One Time Password) has been verified successfully.',
//         buttonText: 'Continue',
//         onTapNavigation: '',
//       ),
//     ).whenComplete(() {
//       setState(() {
//         _isBottomSheetVisible = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final theme = Theme.of(context).textTheme;

//     return Scaffold(
//       backgroundColor: AppColors.secondaryColor,
//       resizeToAvoidBottomInset: true,
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(
//                   14.0,
//                   size.height * 0.22,
//                   14.0,
//                   size.height * 0.14,
//                 ),
//                 child: Center(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Logo Container
//                       Container(
//                         height: 100,
//                         width: 100,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           image: DecorationImage(
//                             image: AssetImage('assets/images/main-logo.png'),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'OTP Verification',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w900,
//                           fontSize: 20,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Padding(
//                         padding: EdgeInsets.all(12.0),
//                         child: Text(
//                           textAlign: TextAlign.center,
//                           'Kindly enter the 6 digit code sent to your\nphone number or email.',
//                         ),
//                       ),
//                       const SizedBox(height: 24),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(6, (index) {
//                           return Container(
//                             width: 40,
//                             margin: const EdgeInsets.symmetric(horizontal: 5),
//                             child: TextField(
//                               controller: _controllers[index],
//                               focusNode: _focusNodes[index],
//                               maxLength: 1,
//                               keyboardType: TextInputType.number,
//                               textAlign: TextAlign.center,
//                               decoration: const InputDecoration(
//                                 counterText: '', // Hides the length counter
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black54),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black),
//                                 ),
//                               ),
//                               onChanged: (value) {
//                                 _handleInput(index); // Handle focus movement
//                                 if (_controllers.every((controller) =>
//                                     controller.text.isNotEmpty)) {
//                                   otpVerification(); // Automatically verify when all fields are filled
//                                 }
//                               },
//                               onSubmitted: (_) => _handleInput(index),
//                               // Detect paste events
//                               inputFormatters: [
//                                 TextInputFormatter.withFunction(
//                                     (oldValue, newValue) {
//                                   // Check if the pasted text is 6 digits long
//                                   if (newValue.text.length == 6) {
//                                     _handlePaste(newValue.text);
//                                   }
//                                   return newValue;
//                                 }),
//                               ],
//                             ),
//                           );
//                         }),
//                       ),

//                       const SizedBox(height: 28),
                  
//                       const Spacer(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             // Blur effect when the bottom sheet is visible
//             if (_isBottomSheetVisible)
//               BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                 child: Container(
//                   color: Colors.black.withOpacity(0.2),
//                 ),
//               ),
//             if (_isLoading)
//               Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 color: Colors.white70,
//                 child: Center(
//                   child: Container(
//                     height: 50,
//                     width: 50,
//                     color: Colors.transparent,
//                     child: const NutsActivityIndicator(),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
