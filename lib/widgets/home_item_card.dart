import 'package:flutter/material.dart';
import 'package:mnm_vendor/app_colors.dart';

class HomeItemCard extends StatelessWidget {
  final String imageUrl, title, value;
  const HomeItemCard(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 155,
        height: 155,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imageUrl, width: 80, height: 80),
              // Image.asset('assets/images/gif1.gif', width: 80, height: 80),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(color: Colors.grey[900]),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
