import 'package:flutter/material.dart';
import 'package:mnm_vendor/app_colors.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  String leftButtonText, rightButtonText;
  final Widget body;
  final VoidCallback onTapRight;
  VoidCallback? onTapLeft;

  CustomAlertDialog({
    super.key,
    this.leftButtonText = 'No',
    this.rightButtonText = 'Yes',
    this.onTapLeft,
    required this.onTapRight,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(child: Text(title)),
      content: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.01),
            child: body,
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  // if (onTapLeft != null) {
                  //   onTapLeft!();
                  // }
                },
                child: Container(
                  height: size.height * 0.04,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.errorColor,
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.onPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.03),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  onTapRight();
                },
                child: Container(
                  height: size.height * 0.04,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.green,
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.onPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

void showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required Widget body,
  String leftButtonText = 'No',
  String rightButtonText = 'Yes',
  VoidCallback? onTapLeft,
  required VoidCallback onTapRight,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomAlertDialog(
        title: title,
        body: body,
        leftButtonText: leftButtonText,
        rightButtonText: rightButtonText,
        onTapLeft: onTapLeft ?? () => Navigator.of(context).pop(),
        onTapRight: onTapRight,
      );
    },
  );
}
