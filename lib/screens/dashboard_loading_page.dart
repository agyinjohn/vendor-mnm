import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardLoadingScreen extends StatelessWidget {
  const DashboardLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerWidget.rectangular(
                  width: screenWidth * 0.4, // 40% of screen width
                  height: 20,
                ),
                const ShimmerWidget.circular(
                  width: 30,
                  height: 30,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerWidget.rectangular(
                  width: screenWidth * 0.40, // 45% of screen width
                  height: 100,
                ),
                ShimmerWidget.rectangular(
                  width: screenWidth * 0.40, // 45% of screen width
                  height: 100,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerWidget.rectangular(
                  width: screenWidth * 0.40, // 45% of screen width
                  height: 100,
                ),
                ShimmerWidget.rectangular(
                  width: screenWidth * 0.40, // 45% of screen width
                  height: 100,
                ),
              ],
            ),
            const SizedBox(height: 30),
            ShimmerWidget.rectangular(
              width: screenWidth * 0.3, // 30% of screen width
              height: 20,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const ShimmerWidget.circular(
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerWidget.rectangular(
                                width: screenWidth * 0.5, // 50% of screen width
                                height: 20,
                              ),
                              const SizedBox(height: 8),
                              ShimmerWidget.rectangular(
                                width: screenWidth * 0.3, // 30% of screen width
                                height: 15,
                              ),
                              const SizedBox(height: 8),
                              ShimmerWidget.rectangular(
                                width: screenWidth * 0.7, // 30% of screen width
                                height: 50,
                              ),
                              const SizedBox(height: 8),
                              ShimmerWidget.rectangular(
                                width: screenWidth * 0.7, // 30% of screen width
                                height: 50,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ShimmerWidget for placeholders
class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({
    super.key,
    required this.width,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
  }) : shapeBorder = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[400]!,
          shape: shapeBorder,
        ),
      ),
    );
  }
}
