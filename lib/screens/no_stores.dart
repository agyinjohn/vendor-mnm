import 'package:flutter/material.dart';
import 'package:mnm_vendor/screens/dashboard_page.dart';
import 'package:mnm_vendor/widgets/custom_button.dart';

class NoStores extends StatefulWidget {
  const NoStores({super.key});

  @override
  State<NoStores> createState() => _NoStoresState();
}

class _NoStoresState extends State<NoStores> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('Failed to load store or no store'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 10),
            child: CustomButton(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashboardPage()),
                      (route) => false);
                },
                title: 'Reload'),
          )
        ],
      ),
    );
  }
}
