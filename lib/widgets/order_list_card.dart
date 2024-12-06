import 'package:flutter/material.dart';

// import '../commons/app_colors.dart';
// import '../screens/new_screens/dashboard_fragments/orders_thread/order_details_page.dart';
import '../app_colors.dart';
import '../screens/dashboard_fragments/orders_thread/order_detail.page.dart';
import 'custom_button.dart';

class OrderListCard extends StatefulWidget {
  final String orderId, pickUp, dropOff;
  final double totalAmount;
  bool showButton;
  OrderListCard(
      {super.key,
      this.showButton = true,
      required this.orderId,
      required this.pickUp,
      required this.dropOff,
      required this.totalAmount});

  @override
  State<OrderListCard> createState() => _OrderListCardState();
}

class _OrderListCardState extends State<OrderListCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    // Debug print to check the value of showButton
    // print('showButton: ${widget.showButton}');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppColors.backgroundColor,
      ),
      width: double.infinity,
      height: size.height * 0.14,
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order ID: #${widget.orderId}'),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: size.width * 0.2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pick up:',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  'Drop Off:',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.008),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                widget.pickUp,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                widget.dropOff,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Total Amount'),
                SizedBox(height: size.height * 0.01),
                Text(
                  widget.totalAmount.toStringAsFixed(2),
                  style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.errorColor2),
                ),
                if (widget.showButton)
                  SizedBox(
                      height: size.height * 0.042,
                      width: size.width * 0.36,
                      child: CustomButton(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OrderDetailPage(
                                          orderNumber: '0001',
                                          customerName: 'John Doe',
                                        )));
                          },
                          title: 'View Details'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
