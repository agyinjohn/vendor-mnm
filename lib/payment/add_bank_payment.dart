import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:mnm_vendor/widgets/showsnackbar.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_colors.dart';
import '../utils/providers/add_and_fetch_payments_methods.dart';
import '../widgets/custom_button.dart';

final paymentChannelsProvider =
    StateNotifierProvider<PaymentChannelsNotifier, List<PaymentChannel>>(
  (ref) => PaymentChannelsNotifier(),
);

class PaymentChannel {
  final String name;
  final String code;

  PaymentChannel({required this.name, required this.code});
}

class PaymentChannelsNotifier extends StateNotifier<List<PaymentChannel>> {
  PaymentChannelsNotifier() : super([]);

  Future<void> fetchPaymentChannels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token not found");

      final response = await fetchPaymentChannelsAPI(token);
      state = response
          .map((channel) =>
              PaymentChannel(name: channel['name'], code: channel['code']))
          .toList();
    } catch (error) {
      print("Error fetching payment channels: $error");
    }
  }

  Future<List<dynamic>> fetchPaymentChannelsAPI(String token) async {
    const url = "${AppColors.url}/vendor/channels/bank";
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return List<dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load payment channels");
    }
  }
}

class AddbankCard extends ConsumerStatefulWidget {
  const AddbankCard({super.key});
  static const routeName = '/add-card-account';
  @override
  ConsumerState<AddbankCard> createState() => _AddbankCardState();
}

class _AddbankCardState extends ConsumerState<AddbankCard> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  String? _selectedCode;
  bool isLoading = false;
  // Future<void> _loadEmailFromToken() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token =
  //         prefs.getString('token'); // Replace 'auth_token' with your token key

  //     if (token != null) {
  //       final decodedToken = JwtDecoder.decode(token);
  //       // print(decodedToken);
  //       final email =
  //           decodedToken['email']; // Ensure the token has an 'email' field

  //       if (email != null) {
  //         setState(() {
  //           _emailController.text = email; // Set as placeholder
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print('Error decoding token: $e');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _loadEmailFromToken();
    ref.read(paymentChannelsProvider.notifier).fetchPaymentChannels();
  }

  @override
  Widget build(BuildContext context) {
    // final paymentMethods = ref.watch(paymentProvider);
    final paymentChannels = ref.watch(paymentChannelsProvider);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(IconlyLight.arrow_left_2),
              onPressed: () {
                Navigator.of(context).pop();
              },
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            );
          },
        ),
        title: Text(
          'Add Account',
          style: theme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.03),
                  Text('Add Card Wallet', style: theme.titleMedium),
                  SizedBox(height: size.height * 0.024),
                  Text('Select bank', style: theme.bodyLarge),
                  SizedBox(height: size.height * 0.01),
                  DropdownButtonFormField<String>(
                    value: _selectedCode,
                    items: paymentChannels.map((channel) {
                      return DropdownMenuItem<String>(
                        value: channel.code,
                        child: Text(channel.name),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCode = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.024),
                  Text('Account number', style: theme.bodyLarge),
                  SizedBox(height: size.height * 0.01),
                  TextFormField(
                    controller: _accountController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: 'E.g. 30242424242',
                      hintStyle: theme.bodyMedium,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: size.height * 0.024),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1, child: Text('CVV', style: theme.bodyLarge)),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 1,
                          child: Text('Expiry Date', style: theme.bodyLarge)),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _cvvController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                  3), // Limit to 3 digits for CVV
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[300],
                              hintText: '123',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _expiryDateController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                  4), // MMYY format
                              ExpiryDateInputFormatter(), // Custom formatter for MM/YY
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[300],
                              hintText: 'MM/YY',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.024),
                  Text('Account Name', style: theme.bodyLarge),
                  SizedBox(height: size.height * 0.01),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: 'John Doe',
                      hintStyle: theme.bodyMedium,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: size.height * 0.2),
                  CustomButton(
                    onTap: () async {
                      //4531 0800 8054 5330
                      if (_selectedCode != null &&
                          _nameController.text.isNotEmpty &&
                          _accountController.text.isNotEmpty) {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          await ref
                              .read(paymentProvider.notifier)
                              .addPaymentMethod(
                                name: _nameController.text,
                                paymentType: 'bank',
                                accountNumber: _accountController.text,
                                bankCode: _selectedCode!,
                              );
                          showCustomSnackbar(
                              context: context,
                              message: 'Payment method added successfully');
                          Navigator.of(context).pop();
                        } catch (e) {
                          showCustomSnackbar(
                              context: context, message: e.toString());
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } else {
                        showCustomSnackbar(
                            context: context,
                            message: 'Please all fields are required',
                            duration: const Duration(seconds: 10));
                      }
                    },
                    title: 'Save this wallet',
                  ),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
              if (isLoading)
                Container(
                  width: double.infinity,
                  height: size.height * 0.85,
                  color: Colors.white54,
                  child: const Center(
                    child: NutsActivityIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

// class ExpiryDateInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     var text = newValue.text;
//     if (text.length == 2 && !text.contains('/')) {
//       text = '$text/';
//     }
//     return TextEditingValue(
//       text: text,
//       selection: TextSelection.collapsed(offset: text.length),
//     );
//   }
// }
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', ''); // Remove any existing slashes
    if (text.length > 4) {
      text = text.substring(0, 4); // Limit to 4 characters (MMYY)
    }

    // Automatically insert a slash after the first two digits
    if (text.length >= 2) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }

    // Ensure the cursor stays at the right position
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
