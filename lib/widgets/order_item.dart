import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:mnm_vendor/screens/dashboard_fragments/orders_thread/order_detail.page.dart';
import 'package:mnm_vendor/screens/dashboard_loading_page.dart';
import 'package:mnm_vendor/utils/formated_date.dart';
import 'package:mnm_vendor/utils/providers/orders_provider.dart';
import 'package:mnm_vendor/widgets/custom_button.dart';
import 'package:mnm_vendor/widgets/showsnackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_colors.dart';
import '../services/order_services.dart';

class OrderItem extends ConsumerStatefulWidget {
  final String orderNumber, name, items, status, createdAt;
  final Color statusColor;
  final List<dynamic> orderDetail;
  const OrderItem({
    super.key,
    required this.orderNumber,
    required this.name,
    required this.items,
    required this.status,
    required this.statusColor,
    required this.createdAt,
    this.orderDetail = const [],
  });

  @override
  ConsumerState<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends ConsumerState<OrderItem> {
  bool isLoading = false;
  String? errorMessage;

  void _updateOrderStatus(String status, String orderId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    print(token);
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await OrderService.updateOrderStatus(
        orderId: orderId,
        status: status,
        authToken: token!,
      );
      await ref.read(recentOrdersProvider.notifier).fetchRecentOrders();
      // Success response
      showCustomSnackbar(
          context: context, message: 'Order status updated successfully!');
      // Handle post-update logic (e.g., navigate or refresh)
    } catch (e) {
      // Error response
      setState(() {
        errorMessage = e.toString();
      });
      showCustomSnackbar(context: context, message: errorMessage!);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return isLoading
        ? ShimmerWidget.rectangular(
            width: size.width * 0.40, height: size.height * 0.70)
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(IconlyBroken.paper),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              'Order #${widget.orderNumber}',
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            child: Text(
                              '| ${widget.name}',
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Spacer(),
                          CircleAvatar(
                              radius: 4, backgroundColor: widget.statusColor),
                          const SizedBox(width: 3),
                          Text(
                            widget.status.toLowerCase(),
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.items,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            formatDateTime(widget.createdAt),
                            style: const TextStyle(fontSize: 11),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderDetailPage(
                                          orderNumber: widget.orderNumber,
                                          customerName: widget.name,
                                          createdAt: widget.createdAt,
                                          itemDetail: widget.orderDetail,
                                        ))),
                            child: const Text(
                              'View details',
                              style: TextStyle(
                                color: Color.fromARGB(255, 18, 159, 161),
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (widget.status == 'PENDING')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                                height: 35,
                                onTap: () {
                                  _updateOrderStatus(
                                      'ACCEPTED', widget.orderNumber);
                                },
                                title: 'Accept '),
                            const SizedBox(
                              width: 19,
                            ),
                            CustomButton(
                                height: 35,
                                onTap: () {
                                  _updateOrderStatus(
                                      'REJECTED', widget.orderNumber);
                                },
                                title: 'Reject ')
                          ],
                        ),
                      const Divider(color: AppColors.cardColor, thickness: 2),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class GenerateOrderList extends StatelessWidget {
  final List<OrderItem> list;
  const GenerateOrderList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            OrderItem(
              createdAt: 'last yeat',
              orderNumber: list[index].orderNumber,
              name: list[index].name,
              items: list[index].items,
              statusColor: list[index].statusColor,
              status: list[index].status,
            ),
            if (index < list.length - 1)
              const Divider(color: AppColors.cardColor, thickness: 3),
          ],
        );
      },
    );
  }
}
