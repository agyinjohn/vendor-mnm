import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:mnm_vendor/app_colors.dart';
import 'package:mnm_vendor/utils/formated_date.dart';
import 'package:mnm_vendor/utils/order_list_data.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
// import '../../../widgets/order_item.dart';
import '../../../utils/providers/orders_provider.dart';
import 'orders_list_page.dart';

class OrderListInitialPage extends ConsumerStatefulWidget {
  final String pageTitle;
  final String filterStatus;
  const OrderListInitialPage({
    super.key,
    required this.pageTitle,
    required this.filterStatus,
  });

  @override
  ConsumerState<OrderListInitialPage> createState() =>
      _OrderListInitialPageState();
}

class _OrderListInitialPageState extends ConsumerState<OrderListInitialPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrders();
  }

  fetchOrders() async {
    await ref.read(ordersProvider.notifier).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: Navigator.of(context).pop,
          child: const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Icon(IconlyLight.arrow_left_2),
              ),
              Text(
                'Back',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        title: Text(
          widget.pageTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 46,
                  child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: const Icon(Icons.filter_list),
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
                const SizedBox(height: 18),
                Expanded(
                  child: ordersState.when(
                      data: (data) {
                        if (data.isEmpty) {
                          return const Center(child: Text("No orders found"));
                        }
                        final allFilteredOrdersEmpty = data.keys.every((date) {
                          final orders = data[date] as List;
                          return orders
                              .where((o) =>
                                  o['vendorStatus'] == widget.filterStatus)
                              .isEmpty;
                        });
                        if (allFilteredOrdersEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/total-orders.gif',
                                height: 170,
                                width: 100,
                              ),
                              const Text('You have no orders in this category')
                            ],
                          );
                        }
                        return ListView.builder(
                          itemCount: data.keys.length,
                          itemBuilder: (context, index) {
                            final date = data.keys.elementAt(index);
                            final orders = data[date] as List;
                            final filteredOrders = orders
                                .where((o) =>
                                    o['vendorStatus'] == widget.filterStatus)
                                .toList();
                            // print(filteredOrders);

                            if (filteredOrders.isEmpty) {
                              return const SizedBox.shrink(
                                child: Text(
                                    'You have no orders in this category yet'),
                              );
                            }
                            return GestureDetector(
                                onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderListPage(
                                          orders: filteredOrders,
                                          pageTitle: formatDate(date),
                                          orderList: completedOrdersList,
                                        ),
                                      ),
                                    ),
                                child: CustomCard(date: formatDate(date)));
                          },
                        );
                      },
                      error: (error, stackTrace) => Center(
                            child: Text('An error occured$error'),
                          ),
                      loading: () => const NutsActivityIndicator()),
                ),
                // Expanded(
                //   child: GenerateOrderList(
                //     list: completedOrdersByDate,
                //     onCardTap: (date) {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => OrderListPage(
                //             pageTitle: date,
                //             orderList: completedOrdersList,
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GenerateOrderList extends StatelessWidget {
  final List<CustomCard> list;
  final Function(String) onCardTap;

  const GenerateOrderList({
    super.key,
    required this.list,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onCardTap(list[index].date),
          child: list[index],
        );
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  final String date;
  const CustomCard({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        height: 48,
        width: double.infinity,
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(IconlyBroken.calendar),
            const SizedBox(width: 8),
            Text(
              date,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Icon(IconlyLight.arrow_right_2),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}
