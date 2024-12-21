// import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/screens/error_page.dart';
import 'package:mnm_vendor/utils/formated_date.dart';
import 'package:mnm_vendor/utils/providers/orders_provider.dart';
import 'package:mnm_vendor/widgets/home_item_card.dart';
import 'package:iconly/iconly.dart';
import 'package:mnm_vendor/widgets/showsnackbar.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_colors.dart';
import '../../services/order_services.dart';
import '../../widgets/order_item.dart';

class HomeFragment extends ConsumerStatefulWidget {
  // final String orderNumber, name, items;
  const HomeFragment({super.key});

  @override
  ConsumerState<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends ConsumerState<HomeFragment> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecentOrders();
  }

  getRecentOrders() async {
    await ref.read(recentOrdersProvider.notifier).fetchRecentOrders();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final recentOrders = ref.watch(recentOrdersProvider);
    print(recentOrders);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 0),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HomeItemCard(
                        imageUrl: 'assets/images/total-orders.gif',
                        title: 'Total Order',
                        value: '100',
                      ),
                      SizedBox(width: 6),
                      HomeItemCard(
                        imageUrl: 'assets/images/total-revenue.gif',
                        title: 'Total Revenue',
                        value: 'GHC 10,000.00',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HomeItemCard(
                        imageUrl: 'assets/images/pending-orders.gif',
                        title: 'Pending Orders',
                        value: '50',
                      ),
                      SizedBox(width: 10),
                      HomeItemCard(
                        imageUrl: 'assets/images/products.gif',
                        title: 'Products',
                        value: '50',
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      Icon(IconlyLight.time_circle),
                      SizedBox(width: 6),
                      Text(
                        'Recent Orders',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(color: AppColors.cardColor, thickness: 3),
                  // const SizedBox(height: 6),
                  SizedBox(
                    height: size.height * 0.25,
                    child: recentOrders.when(
                        data: (data) {
                          print("Order for recent${data[0]['createdAt']}");
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final List<String> itemNames =
                                    (data[index]['items'] as List<dynamic>)
                                        .map((item) => item['itemSizeId']
                                            ['itemId']['name'] as String)
                                        .toList();
                                print(data[index]['vendorStatus']);
                                if (data.isEmpty) {
                                  return const Center(
                                    child: Text('You have no recent orders'),
                                  );
                                }
                                return OrderItem(
                                    orderNumber: data[index]['_id'],
                                    name: data[index]['customerId']['name'],
                                    items: itemNames.join(','),
                                    status: data[index]['vendorStatus'],
                                    orderDetail: data[index]['items'],
                                    statusColor:
                                        data[index]['vendorStatus'] == 'PENDING'
                                            ? Colors.yellow
                                            : data[index]['vendorStatus'] ==
                                                    'ACCEPTED'
                                                ? Colors.orange
                                                : data[index]['vendorStatus'] ==
                                                        'REJECTED'
                                                    ? Colors.red
                                                    : Colors.green,
                                    createdAt: data[index]['createdAt']);
                              });
                        },
                        error: (onb, stacktrace) => const Center(
                              child: SizedBox(
                                height: 100,
                              ),
                            ),
                        loading: () => const Center(
                              child: NutsActivityIndicator(),
                            )),
                  ),
                  // SizedBox(
                  //   height: size.width * 0.45,
                  //   child: const SingleChildScrollView(
                  //     child: Column(
                  //       children: [
                  //         OrderItem(
                  //             createdAt: 'last year',
                  //             items: '2x Burger, 1x Fries, 1x Chicken Bucket',
                  //             name: 'Mohammed Ali',
                  //             orderNumber: '01234',
                  //             status: 'Awaiting confirmation',
                  //             statusColor: Colors.yellow),
                  //         Divider(color: AppColors.cardColor, thickness: 3),
                  //         SizedBox(height: 6),
                  //         OrderItem(
                  //             createdAt: 'last year',
                  //             items: '1x Fries, 1x Coca Cola, 2x Coconut Bread',
                  //             name: 'Name',
                  //             orderNumber: '12345',
                  //             status: 'Awaiting confirmation',
                  //             statusColor: Colors.yellow),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
