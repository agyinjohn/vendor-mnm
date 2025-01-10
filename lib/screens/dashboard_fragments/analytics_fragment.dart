import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../app_colors.dart';

class AnalyticsFragment extends StatelessWidget {
  const AnalyticsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme; // Access the TextTheme

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(size.width * 0.018),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.03),
            Text(
              'General Overview',
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.025),
            _buildCustomerOverview(context),
            SizedBox(height: size.height * 0.01),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildOrdersReview(context),
                ),
                SizedBox(width: size.width * 0.01),
                Expanded(
                  flex: 1,
                  child: _buildRating(context),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.04),
            Text(
              'Promotion Performance',
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.015),
            _buildPromotionPerformance(context),
            SizedBox(height: size.height * 0.04),
            Text(
              'Sales Overview',
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.015),
            _buildSalesOverview(context),
            SizedBox(height: size.height * 0.02),
            _buildSalesChart(context),
            SizedBox(height: size.height * 0.04),
            Text(
              'Best Selling Products',
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.015),
            _buildBestSellingProducts(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerOverview(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.08,
              width: size.height * 0.08,
              child: Center(
                child: Image.asset(
                  'assets/images/Customer.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: size.width * 0.018),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Overview',
                    style: theme.titleSmall,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New:',
                              style: theme.bodyMedium,
                            ),
                            Row(
                              children: [
                                Text(
                                  '70',
                                  style: theme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: size.width * 0.036),
                                const Icon(Icons.arrow_upward,
                                    color: Colors.green, size: 15),
                                Text(
                                  '34%',
                                  style: theme.bodyMedium?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: size.width * 0.036),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Returning:',
                              style: theme.bodyMedium,
                            ),
                            Row(
                              children: [
                                Text(
                                  '30',
                                  style: theme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: size.width * 0.036),
                                const Icon(Icons.arrow_downward,
                                    color: Colors.red, size: 15),
                                Text(
                                  '74%',
                                  style: theme.bodyMedium?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersReview(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.008, vertical: size.width * 0.03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.05,
              width: size.height * 0.05,
              child: Center(
                child: Image.asset(
                  'assets/images/review.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: size.width * 0.01),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Orders Review',
                    style: theme.titleSmall,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Text(
                        'Total orders:',
                        style: theme.bodyMedium,
                      ),
                      SizedBox(width: size.width * 0.01),
                      Text(
                        '200',
                        style: theme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: size.width * 0.01),
                      const Icon(Icons.arrow_downward,
                          color: Colors.red, size: 15),
                      Text(
                        '74%',
                        style: theme.bodyMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRating(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.008, vertical: size.width * 0.03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.05,
              width: size.height * 0.05,
              child: Center(
                child: Image.asset(
                  'assets/images/Star Filled.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: size.width * 0.01),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rating',
                    style: theme.titleSmall,
                  ),
                  SizedBox(height: size.height * 0.01),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          '4.5',
                          style: theme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: size.width * 0.01),
                        Text(
                          'Good',
                          style: theme.bodyMedium?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionPerformance(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.08,
                width: size.height * 0.08,
                child: Center(
                  child: Image.asset('assets/images/New Ticket.png',
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: size.width * 0.038),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Active Promo Code:',
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(size.height * 0.008),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: Text(
                            'SUMMER20',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.07),
                      SizedBox(
                        height: size.height * 0.038,
                        width: size.height * 0.038,
                        child: Center(
                          child: Image.asset('assets/images/Copy.png',
                              fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              // SizedBox(width: size.width * 0.018),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.04,
                      width: size.height * 0.04,
                      child: Image.asset('assets/images/Share.png',
                          fit: BoxFit.cover),
                    ),
                    const Text('share'),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _buildSalesOverview(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme; // Access the TextTheme

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  'Total Sales',
                  style: theme.titleSmall, // Using TextTheme style
                ),
                SizedBox(height: size.height * 0.015),
                Text(
                  'GHC 25,000',
                  style: theme.headlineSmall?.copyWith(
                    // Using TextTheme style
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Total Avg. Sales',
                  style: theme.titleSmall, // Using TextTheme style
                ),
                SizedBox(height: size.height * 0.015),
                Text(
                  'GHC 1,200',
                  style: theme.headlineSmall?.copyWith(
                    // Using TextTheme style
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme; // Access the TextTheme
    final List<double> values = [2750, 2250, 2900, 2250, 2500, 3000, 1500];

    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Trend (Weekly trend)',
              style: theme.titleSmall, // Using TextTheme style
            ),
            SizedBox(height: size.height * 0.02),
            SizedBox(
              height: size.height * 0.36,
              child: LineChart(
                LineChartData(
                  maxY: 3000,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        values.length,
                        (index) => FlSpot(index.toDouble(), values[index]),
                      ),
                      isCurved: true,
                      color: Colors.deepPurpleAccent,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.deepPurpleAccent,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(),
                      left: BorderSide(),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun'
                          ];
                          if (value.toInt() < days.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                days[value.toInt()],
                                style: theme.bodySmall, // Using TextTheme style
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval:
                            500, // Added interval for cleaner Y-axis labels
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: theme.bodySmall, // Using TextTheme style
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.016),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.deepPurpleAccent),
                ),
                SizedBox(width: size.width * 0.014),
                Text(
                  'Amount of money',
                  style: theme.bodySmall, // Using TextTheme style
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBestSellingProducts(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme; // Access the TextTheme

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item(s)',
                  style: theme.bodySmall
                      ?.copyWith(fontSize: 14), // Using TextTheme style
                ),
                Text(
                  'Quantity(units)',
                  style: theme.bodySmall
                      ?.copyWith(fontSize: 14), // Using TextTheme style
                ),
              ],
            ),
            Divider(
              color: Colors.black.withOpacity(0.4),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone',
                      style: theme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14), // Using TextTheme style
                    ),
                    SizedBox(height: size.height * 0.008),
                    Text(
                      'Laptop',
                      style: theme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14), // Using TextTheme style
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '500',
                      style: theme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14), // Using TextTheme style
                    ),
                    SizedBox(height: size.height * 0.008),
                    Text(
                      '450',
                      style: theme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14), // Using TextTheme style
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
