import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../app_colors.dart';

class FoodItem extends StatelessWidget {
  final String imageUrl;
  final String description;
  final String price;
  final String rating;
  final int quantity;

  const FoodItem({
    super.key,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.rating,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300), // Subtle border color
        borderRadius: BorderRadius.circular(16), // Smooth rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Soft shadow for depth
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3), // Offset the shadow
          ),
        ],
      ),
      height: size.height * 0.28, // Adjusted height for better fit
      width: size.width * 0.44,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Rating Stack
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: SizedBox(
              height: size.height * 0.19,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red, // Temporary color for missing image
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  // Positioned Rating Container
                  Positioned(
                    right: 10,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.6), // Translucent background
                        borderRadius:
                            BorderRadius.circular(12), // Rounded rating box
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            IconlyBold.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8), // Space between image and description

          // Description Text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Text(
              description,
              style: TextStyle(
                fontSize: size.width * 0.035,
                fontWeight: FontWeight.w600,
                color: Colors.black87, // Slightly softened black text
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),

          // Price and Quantity Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price Text
                Text(
                  'GH¢ $price',
                  style: TextStyle(
                    fontSize: size.width * 0.035,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                // Quantity Text
                Text(
                  'Qty: $quantity',
                  style: TextStyle(
                    fontSize: size.width * 0.032,
                    color: Colors.black54, // Subtle color for quantity
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10), // Bottom padding
        ],
      ),
    );
  }
}
