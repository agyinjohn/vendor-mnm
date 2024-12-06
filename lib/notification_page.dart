import 'package:flutter/material.dart';
import 'package:mnm_vendor/app_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  static const routeName = 'notification-page';
  // Dummy notification data
  final List<Map<String, String>> notifications = const [
    {
      'title': 'New Order Received',
      'description': 'You have received a new order for 3 items.',
      'date': 'Sept 20, 2024'
    },
    {
      'title': 'Payment Received',
      'description': 'Your payment of \$50.00 has been processed.',
      'date': 'Sept 18, 2024'
    },
    {
      'title': 'Verification Complete',
      'description': 'Your account has been verified successfully.',
      'date': 'Sept 15, 2024'
    },
    {
      'title': 'New Review',
      'description': 'You have a new 5-star review for your store.',
      'date': 'Sept 12, 2024'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  // Build a notification card widget
  Widget _buildNotificationCard(Map<String, String> notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification title
            Text(
              notification['title']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Notification description
            Text(
              notification['description']!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Notification date
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                notification['date']!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
