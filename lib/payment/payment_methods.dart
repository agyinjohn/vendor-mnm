import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:mnm_vendor/models/payment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../app_colors.dart';
import '../providers/account_provider.dart';
import '../services/payment_services_api.dart';
import '../utils/alert_diallogue.dart';

class PaymentMethodsPage extends ConsumerStatefulWidget {
  const PaymentMethodsPage({super.key});
  static const routeName = '/payment-methods';

  @override
  ConsumerState<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends ConsumerState<PaymentMethodsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;
    final accounts = ref.watch(accountProvider);
    final paymentMethodsAsyncValue = ref.watch(paymentMethodsProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          'Payment Methods',
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
              // SizedBox(height: size.height * 0.01),
              paymentMethodsAsyncValue.when(
                  data: (paymentMethods) {
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection:
                            Axis.horizontal, // Enables horizontal scrolling
                        itemCount: paymentMethods.length,
                        itemBuilder: (context, index) {
                          final paymentMethod = paymentMethods[index];
                          return _buildAccountCard(context,
                              paymentMethod.bankCode, ref, paymentMethod);
                        },
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) {
                    return ElevatedButton(
                        onPressed: () async {
                          const String baseUrl = AppColors.baseURL;

                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final token = prefs.getString('token');
                          final url = Uri.parse('$baseUrl/payment-methods');
                          final response = await http.get(
                            url,
                            headers: {
                              'Authorization': 'Bearer $token',
                              'Content-Type': 'application/json',
                            },
                          );

                          if (response.statusCode == 200) {
                            final List<dynamic> data =
                                jsonDecode(response.body);
                            data
                                .map((json) => PaymentMethod.fromJson(json))
                                .toList();
                          } else {
                            throw Exception("Failed to load payment methods");
                          }
                        },
                        child: const Text('Reload'));
                  }),
              if (accounts.isNotEmpty)
                Text('Your Accounts', style: theme.titleMedium),
              SizedBox(height: size.height * 0.01),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...[
                      SizedBox(height: size.height * 0.01),
                      ...accounts.map((account) => _buildAccountCard(
                          context,
                          'account',
                          ref,
                          PaymentMethod(
                              id: '',
                              userId: '',
                              type: '',
                              name: '',
                              accountNumber: '',
                              bankCode: '',
                              recipientCode: ''))),
                      SizedBox(height: size.height * 0.04),
                    ],
                  ],
                ),
              ),
              if (accounts.isNotEmpty) SizedBox(height: size.height * 0.03),
              Text('Mobile Money', style: theme.titleMedium),
              SizedBox(height: size.height * 0.01),
              _buildAddCard(
                  context, Icons.phone_iphone_outlined, 'Add mobile money', () {
                Navigator.pushNamed(context, '/add-account');
              }),
              SizedBox(height: size.height * 0.03),
              Text('Bank Card', style: theme.titleMedium),
              SizedBox(height: size.height * 0.01),
              _buildAddCard(
                  context, Icons.credit_card, 'Add a credit/debit card', () {
                Navigator.pushNamed(context, '/add-card-account');
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddCard(
      BuildContext ctx, IconData icon, String title, VoidCallback onTap) {
    final size = MediaQuery.of(ctx).size;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: AppColors.cardColor),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Center(
          child: Row(
            children: [
              Icon(
                icon,
                size: size.width * 0.1,
                color: Colors.grey[500],
              ),
              SizedBox(width: size.width * 0.02),
              Text(title),
              const Spacer(),
              GestureDetector(
                onTap: onTap,
                child: const Icon(
                  Icons.add,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard(
      BuildContext ctx, String type, WidgetRef ref, PaymentMethod payment) {
    final size = MediaQuery.of(ctx).size;
    return Padding(
      padding: EdgeInsets.only(right: size.width * 0.025),
      child: Container(
        height: size.height * 0.19,
        width: size.width * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: type == 'MTN'
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
                                  color: type == 'MTN'
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            Text(
                              'Number:',
                              style: TextStyle(
                                  color: type == 'MTN'
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            Text(
                              'Type:',
                              style: TextStyle(
                                  color: type == 'MTN'
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            Text(
                              'BankCode:',
                              style: TextStyle(
                                  color: type == 'MTN'
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
                                    color: type == 'MTN'
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              Text(
                                payment.accountNumber,
                                style: TextStyle(
                                    color: type == 'MTN'
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              Text(
                                payment.type,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: type == 'MTN'
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              Text(
                                payment.bankCode,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: type == 'MTN'
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
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      type == 'MTN'
                          ? Row(
                              children: [
                                Image.asset('assets/images/MTN-logo-1.png'),
                                Image.asset('assets/images/MTN-momo-logo.png'),
                              ],
                            )
                          : Image.asset('assets/images/telecash-logo.png'),
                      GestureDetector(
                        onTap: () {
                          showCustomAlertDialog(
                            context: ctx,
                            title: 'Confirm Deletion',
                            body: const Text(
                                'Are you sure you want to delete this account?'),
                            onTapRight: () {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                const SnackBar(
                                  content: Text('Account deleted successfully'),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColors.errorColor2,
                          ),
                          height: size.height * 0.035,
                          width: size.width * 0.1,
                          child: const Center(
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
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
