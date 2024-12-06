import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mnm_vendor/app_colors.dart';
import '../../../widgets/order_item.dart';

class OrderListPage extends StatelessWidget {
  final String pageTitle;
  final List<OrderItem> orderList;
  final List<dynamic> orders;

  const OrderListPage({
    super.key,
    required this.pageTitle,
    this.orders = const [],
    required this.orderList,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(IconlyLight.arrow_left_2),
              onPressed: () {
                Navigator.of(context).pop();
              },
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            );
          },
        ),
        title: Text(
          pageTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.02),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: size.height * 0.06,
                        child: Center(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: AppColors.cardColor,
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: const Icon(Icons.more_vert_outlined))
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(color: AppColors.cardColor, thickness: 3),
                Expanded(
                    child: GenerateOrderList(
                  order: orders,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GenerateOrderList extends StatelessWidget {
  final List<dynamic> order;
  const GenerateOrderList({super.key, this.order = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: order.length,
      itemBuilder: (context, index) {
        final List<String> itemNames = (order[index]['items'] as List<dynamic>)
            .map((item) => item['itemSizeId']['itemId']['name'] as String)
            .toList();

        // Join the list of names into a single string
        final String itemsString = itemNames.join(', ');
        return OrderItem(
            orderDetail: order[index]['items'],
            createdAt: order[index]['createdAt'],
            orderNumber: order[index]['_id'],
            name: order[index]['customerId']['name'],
            items: itemsString,
            status: order[index]['vendorStatus'],
            statusColor: order[index]['vendorStatus'] == 'PENDING'
                ? Colors.yellow
                : order[index]['vendorStatus'] == 'ACCEPTED'
                    ? Colors.orange
                    : order[index]['vendorStatus'] == 'REJECTED'
                        ? Colors.red
                        : Colors.green);
      },
    );
  }
}
