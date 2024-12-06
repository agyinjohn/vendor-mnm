import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../app_colors.dart';

class SwipeToConfirm extends StatefulWidget {
  final VoidCallback onConfirm;

  const SwipeToConfirm({super.key, required this.onConfirm});

  @override
  State<SwipeToConfirm> createState() => _SwipeToConfirmState();
}

class _SwipeToConfirmState extends State<SwipeToConfirm>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation1 = Tween<double>(begin: 0.5, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _animation2 = Tween<double>(begin: 0.6, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _animation3 = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCircle(double size, double scale, Color color) {
    return Center(
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double baseSize = size.width * 0.6;
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.08),
              Text('Incoming Order',
                  style:
                      theme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: size.height * 0.008),
              Text('You have an incoming order', style: theme.titleMedium),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animation3,
                      builder: (context, child) {
                        return _buildCircle(baseSize * 1.5, _animation3.value,
                            AppColors.primaryColor.withOpacity(0.2));
                      },
                    ),
                    AnimatedBuilder(
                      animation: _animation2,
                      builder: (context, child) {
                        return _buildCircle(baseSize * 1.2, _animation2.value,
                            AppColors.primaryColor.withOpacity(0.5));
                      },
                    ),
                    AnimatedBuilder(
                      animation: _animation1,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            _buildCircle(baseSize, _animation1.value,
                                AppColors.primaryColor.withOpacity(0.7)),
                            Center(
                              child: Image.asset(
                                  'assets/images/incoming-order.gif',
                                  width: size.width * 0.28,
                                  height: size.width * 0.28,
                                  fit: BoxFit.cover),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: SlideAction(
                    text: 'Slide to view order',
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    outerColor: Colors.grey[400]!,
                    submittedIcon: const Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                    innerColor: Colors.white,
                    sliderButtonIcon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                    ),
                    onSubmit: () async {
                      widget.onConfirm();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
