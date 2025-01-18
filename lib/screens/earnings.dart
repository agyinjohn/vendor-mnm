import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

import '../../../utils/providers/user_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/error_alert_dialogue.dart';
import '../app_colors.dart';
import '../utils/providers/earnings_provider.dart';

class Earnings extends ConsumerStatefulWidget {
  const Earnings({super.key});

  @override
  _EarningsState createState() => _EarningsState();
}

class _EarningsState extends ConsumerState<Earnings> {
  String selectedRange = 'This Week';
  bool _isDialogShowing = false;
  final List<String> dateRanges = [
    'Today',
    'This Week',
    'Last Month',
    'Custom Range'
  ];

  List<DropdownMenuItem<String>> get dropdownItems {
    return dateRanges
        .map((range) => DropdownMenuItem(
              value: range,
              child: Text(range),
            ))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    ref.read(earningsSummaryProvider.notifier).fetchEarnings({
      'dateRange': 'today',
      'customStartDate': '',
      'customEndDate': '',
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final currencyFormat =
        NumberFormat.currency(locale: 'en_GH', symbol: 'GHS');
    final user = ref.read(authProvider);
    final queryParams = {
      'dateRange': 'month',
      'customStartDate': '',
      'customEndDate': '',
    };

    final earningsSummaryAsync = ref.watch(earningsSummaryProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Earnings Summary',
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
          child: earningsSummaryAsync.when(
        data: (data) {
          final spots = data.groupedEarnings.asMap().entries.map((entry) {
            int index = entry.key; // Index for x-axis
            final earning = entry.value;
            double amount = earning.amount;
            return FlSpot(index.toDouble(), amount);
          }).toList();
          return Padding(
            padding: EdgeInsets.fromLTRB(
                size.width * 0.04, size.height * 0.0, size.width * 0.04, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Earnings Summary

                SizedBox(height: size.height * 0.02),

                // Earnings Graph
                Container(
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.03),
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: FlTitlesData(
                          show: true,
                          leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: true)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index >= 0 &&
                                  index < data.groupedEarnings.length) {
                                final earning = data.groupedEarnings[index];
                                final date = DateTime.parse(earning.date);
                                final formatedDate =
                                    DateFormat('EEE').format(date);
                                return Text(formatedDate); // Show day
                              }
                              return const SizedBox();
                            },
                          )),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            barWidth: 4,
                            color: AppColors.primaryColor,
                            dotData: const FlDotData(show: true),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                // Dropdown for Date Range
                DropdownButtonFormField<String>(
                  value: selectedRange,
                  items: dropdownItems,
                  onChanged: (value) {
                    setState(() {
                      selectedRange = value!;
                    });
                    if (selectedRange == 'Today') {
                      ref.read(earningsSummaryProvider.notifier).fetchEarnings({
                        'dateRange': 'today',
                        'customStartDate': '',
                        'customEndDate': '',
                      });
                    } else if (selectedRange == 'This Week') {
                      ref.read(earningsSummaryProvider.notifier).fetchEarnings({
                        'dateRange': 'week',
                        'customStartDate': '',
                        'customEndDate': '',
                      });
                    } else {
                      ref.read(earningsSummaryProvider.notifier).fetchEarnings({
                        'dateRange': 'month',
                        'customStartDate': '',
                        'customEndDate': '',
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Filter by Date',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                // Weekly/Daily Earnings & Pending Payouts
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.cardColor,
                  ),
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: Column(
                    children: [
                      buildEarningsRow(
                        title: 'Daily Earnings:',
                        amount: currencyFormat.format(data.dailyEarnings),
                        theme: theme,
                      ),
                      buildEarningsRow(
                        title: 'Weekly Earnings:',
                        amount: currencyFormat.format(data.weeklyEarnings),
                        theme: theme,
                      ),
                      buildEarningsRow(
                        title: 'Pending Payouts:',
                        amount: currencyFormat.format(data.pendingPayouts),
                        theme: theme,
                        color: AppColors.errorColor2,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                // Earnings Details for Completed Orders
                Text(
                  'Earnings Details for Completed Orders',
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: size.height * 0.015),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.cardColor,
                  ),
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: data.orders.isEmpty
                      ? Center(
                          child: Text(
                            'No orders available',
                            style: theme.textTheme.bodyMedium,
                          ),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.orders.length,
                          itemBuilder: (context, index) {
                            final order = data.orders[index];
                            return Column(
                              children: [
                                buildOrderDetail(
                                  date: DateFormat('MMM d, yyyy')
                                      .format(DateTime.parse(order.date)),
                                  orderId:
                                      '#${order.orderId}', // Adjust key if needed
                                  amount: currencyFormat.format(order.amount),
                                  theme: theme,
                                ),
                                if (index < data.orders.length - 1)
                                  const Divider(), // Add divider except for the last item
                              ],
                            );
                          },
                        ),
                ),
                SizedBox(height: size.height * 0.02),

                // Request Withdrawal Button
                CustomButton(
                  onTap: () {
                    Navigator.pushNamed(context, '/request-withdrawal');
                  },
                  title: 'Request Withdrawal',
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          print(error.toString());
          if (!_isDialogShowing) {
            _isDialogShowing = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showErrorDialog(
                context,
                () async {
                  // Close dialog before retry
                  _isDialogShowing = false; // Reset the dialog flag
                  try {
                    await ref
                        .read(earningsSummaryProvider.notifier)
                        .fetchEarnings({
                      'dateRange': 'week',
                      'customStartDate': '',
                      'customEndDate': '',
                    });
                  } catch (e) {
                    // If retry fails, re-show the dialog
                    if (!_isDialogShowing) {
                      _isDialogShowing = true;
                      showErrorDialog(context, () {});
                    }
                  }
                },
              ).then((_) {
                // Reset the dialog flag when the dialog is dismissed
                _isDialogShowing = false;
              });
            });
          }
          // Optionally, return an empty container or placeholder
          return const SizedBox();
        },
        loading: () => Center(
          child: Padding(
            padding: EdgeInsets.only(top: size.height * 0.5),
            child: const NutsActivityIndicator(),
          ),
        ),
      )),
    );
  }

  Widget buildEarningsRow(
      {required String title,
      required String amount,
      required ThemeData theme,
      Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const Spacer(),
          Text(amount,
              style: theme.textTheme.titleMedium?.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget buildOrderDetail(
      {required String date,
      required String orderId,
      required String amount,
      required ThemeData theme}) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: $date', style: theme.textTheme.bodySmall),
            Text('Order ID: $orderId', style: theme.textTheme.bodySmall),
          ],
        ),
        const Spacer(),
        Text(amount, style: theme.textTheme.bodyLarge),
      ],
    );
  }
}
