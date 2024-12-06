import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For charts
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // For star rating

class AnalyticsFragment extends StatelessWidget {
  const AnalyticsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Sales and Sales Trend
            _buildSectionTitle('Sales Overview'),
            _buildTotalSales(),
            _buildSalesTrendChart(),

            const SizedBox(height: 24),

            // Best-selling Products
            _buildSectionTitle('Best-Selling Products'),
            _buildBestSellingProducts(),

            const SizedBox(height: 24),

            // Customer Overview
            _buildSectionTitle('Customer Overview'),
            _buildCustomerAnalytics(),

            const SizedBox(height: 24),

            // Orders Overview
            _buildSectionTitle('Orders Overview'),
            _buildOrderOverview(),

            const SizedBox(height: 24),

            // Marketing Analytics
            _buildSectionTitle('Marketing Performance'),
            _buildMarketingAnalytics(),

            const SizedBox(height: 24),

            // Store Rating
            _buildSectionTitle('Store Rating'),
            _buildStoreRating(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Dummy Total Sales Indicator
  Widget _buildTotalSales() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text('Total Sales', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text(
                  '\$25,000', // Dummy data
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text('Avg. Order Value', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text(
                  '\$120', // Dummy data
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Dummy Sales Trend Chart
  Widget _buildSalesTrendChart() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sales Trend (Last 7 Days)', style: TextStyle(fontSize: 18)),
            SizedBox(height: 200, child: _DummySalesChart()),
          ],
        ),
      ),
    );
  }

  // Dummy Best-selling Products
  Widget _buildBestSellingProducts() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Top Products', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            ListTile(
              title: Text('Laptop'),
              trailing: Text('500 units'),
            ),
            ListTile(
              title: Text('Phone'),
              trailing: Text('450 units'),
            ),
            ListTile(
              title: Text('Headphones'),
              trailing: Text('300 units'),
            ),
          ],
        ),
      ),
    );
  }

  // Dummy Customer Overview
  Widget _buildCustomerAnalytics() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New vs Returning Customers', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('New Customers: 70', style: TextStyle(fontSize: 18)),
                Text('Returning Customers: 30', style: TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Dummy Orders Overview
  Widget _buildOrderOverview() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Orders', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('200 Orders',
                style: TextStyle(fontSize: 28, color: Colors.blue)),
          ],
        ),
      ),
    );
  }

  // Dummy Marketing Analytics
  Widget _buildMarketingAnalytics() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Promotion Performance', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Promo Code: SUMMER20',
                    style: TextStyle(fontSize: 16)),
                Text('Uses: 50', style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // New - Dummy Store Rating
  Widget _buildStoreRating() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Average Store Rating', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Rating Bar
                RatingBarIndicator(
                  rating: 4.5, // Dummy rating
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 30.0,
                ),
                const Text('4.5 (150 reviews)',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy Sales Chart Widget
class _DummySalesChart extends StatelessWidget {
  const _DummySalesChart();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 1000),
              const FlSpot(1, 1200),
              const FlSpot(2, 1500),
              const FlSpot(3, 1300),
              const FlSpot(4, 1700),
              const FlSpot(5, 1900),
              const FlSpot(6, 2000),
            ],
            isCurved: true,
            color: Colors.blue,
            dotData: const FlDotData(show: false),
          ),
        ],
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
        borderData: FlBorderData(show: true),
      ),
    );
  }
}
