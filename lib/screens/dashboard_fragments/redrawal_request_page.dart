import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mnm_vendor/screens/dashboard_fragments/lock_screen.dart';
import 'package:mnm_vendor/widgets/custom_bottom_sheet.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_colors.dart';
import '../../models/payment_model.dart';
import '../../services/payment_services_api.dart';
import '../../widgets/showsnackbar.dart';

class RequestWithdrawalPage extends ConsumerStatefulWidget {
  const RequestWithdrawalPage({super.key});
  static const routeName = '/request-withdrawal';

  @override
  ConsumerState<RequestWithdrawalPage> createState() =>
      _RequestWithdrawalPageState();
}

class _RequestWithdrawalPageState extends ConsumerState<RequestWithdrawalPage> {
  final TextEditingController _amountController = TextEditingController();

  PaymentMethod? _selectedPaymentMethod;
  bool isLoading = false;
  Future<void> _withdrawAmount() async {
    if (_amountController.text.isEmpty || _selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount greater than zero')),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      final response = await http.post(
        Uri.parse('${AppColors.baseURL}/withdraw'),
        headers: {
          'Authorization': 'Bearer $token', // Replace with your token
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': amount,
          'paymentMethodId': _selectedPaymentMethod!.id,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Show success bottom sheet
        // showModalBottomSheet(
        //   context: context,
        //   builder: (_) => SuccessBottomSheet(data: data),
        // );
        showSuccessSheet(context);
      } else {
        // Show error snackbar
        showCustomSnackbar(
            duration: const Duration(seconds: 10),
            context: context,
            message: data['message'] ?? 'An error occurred');
      }
    } catch (e) {
      showCustomSnackbar(
          duration: const Duration(seconds: 10),
          context: context,
          message: 'Failed to process withdrawal');
      // Show error snackbar
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showSuccessSheet(BuildContext context) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SuccessSheet(
        title: 'Withdrawal Successful!',
        message:
            'You have successfully withdraw an amount of GHC ${_amountController.text} from your account.',
        buttonText: 'Continue',
        onTapNavigation: '/verify1',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;
    final paymentMethodsAsyncValue = ref.watch(paymentMethodsProvider);

    return LockScreen(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Request Withdrawal',
            style: theme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.03),
                Text('Enter withdrawal amount(GHS)', style: theme.titleMedium),
                SizedBox(height: size.height * 0.01),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    hintText: 'E.g. 50',
                    hintStyle: theme.bodyMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: size.height * 0.03),
                Text('Select Payment Method', style: theme.titleMedium),
                SizedBox(height: size.height * 0.01),
                paymentMethodsAsyncValue.when(
                  data: (paymentMethods) {
                    if (paymentMethods.isEmpty) {
                      return const Text('No payment methods available.');
                    }
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: paymentMethods.length,
                        itemBuilder: (context, index) {
                          final paymentMethod = paymentMethods[index];

                          final isSelected =
                              _selectedPaymentMethod == paymentMethod;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPaymentMethod = paymentMethod;
                              });
                            },
                            child: Stack(
                              children: [
                                _buildAccountCard(context, paymentMethod.type,
                                    ref, paymentMethod),
                                if (isSelected)
                                  const Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 24,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: ElevatedButton(
                      onPressed: () async {},
                      child: const Text('Reload'),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.3),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonHoverColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: (_amountController.text.isNotEmpty &&
                              _selectedPaymentMethod != null)
                          ? () async {
                              await _withdrawAmount();
                            }
                          : null,
                      child: isLoading
                          ? const NutsActivityIndicator()
                          : const Text(
                              'Cashout',
                              style: TextStyle(color: Colors.white),
                            ),
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

  Widget _buildAccountCard(
      BuildContext ctx, String type, WidgetRef ref, PaymentMethod payment) {
    final size = MediaQuery.of(ctx).size;
    print(type);
    return Padding(
      padding: EdgeInsets.only(right: size.width * 0.025),
      child: Container(
        height: size.height * 0.20,
        width: size.width * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: payment.bankCode == 'MTN'
              ? const Color.fromARGB(255, 255, 203, 5)
              : const Color.fromARGB(255, 155, 1, 1),
        ),
        child: Stack(
          children: [
            // The background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/connect.png',
                fit: BoxFit.cover,
              ),
            ),

            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.26,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name:',
                              style: TextStyle(
                                  color: payment.bankCode == 'MTN'
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            Text(
                              'Number:',
                              style: TextStyle(
                                  color: payment.bankCode == 'MTN'
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            Text(
                              'Type:',
                              style: TextStyle(
                                  color: payment.bankCode == 'MTN'
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            Text(
                              'BankCode:',
                              style: TextStyle(
                                  color: payment.bankCode == 'MTN'
                                      ? Colors.black
                                      : Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: SizedBox(
                          width: size.width * 0.26,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                payment.name,
                                style: TextStyle(
                                    color: payment.bankCode == 'MTN'
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              Text(
                                payment.accountNumber,
                                style: TextStyle(
                                    color: payment.bankCode == 'MTN'
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              Text(
                                payment.type,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: payment.bankCode == 'MTN'
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              Text(
                                payment.bankCode,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: payment.bankCode == 'MTN'
                                        ? Colors.black
                                        : Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.all(size.width * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      payment.bankCode == 'MTN'
                          ? Row(
                              children: [
                                Image.asset('assets/images/MTN-logo-1.png'),
                                Image.asset('assets/images/MTN-momo-logo.png'),
                              ],
                            )
                          : Image.asset('assets/images/telecash-logo.png'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessBottomSheet extends StatelessWidget {
  final Map<String, dynamic> data;

  const SuccessBottomSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 50),
          const SizedBox(height: 16),
          Text(
            'Withdrawal Successful!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Amount: ${data['amount']}'),
          Text('Reference: ${data['reference']}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
