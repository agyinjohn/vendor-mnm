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
import '../../widgets/error_alert_dialogue.dart';
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

  bool _isDialogOpen = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final recentOrders = ref.watch(recentOrdersProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 0),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HomeItemCard(
                      imageUrl: 'assets/images/total-orders.gif',
                      title: 'Completed Orders',
                      value: recentOrders.when(
                          data: (da) {
                            final states = da.stats;
                            return Text("${states.completedOrders}");
                          },
                          error: (error, trace) => const Text(''),
                          loading: () => const NutsActivityIndicator()),
                    ),
                    const SizedBox(width: 6),
                    HomeItemCard(
                      imageUrl: 'assets/images/total-revenue.gif',
                      title: 'Total Revenue',
                      value: recentOrders.when(
                          data: (da) {
                            final states = da.stats;
                            return Text(
                                "GHC ${states.revenue.toStringAsFixed(2)}");
                          },
                          error: (error, trace) => const Text(''),
                          loading: () => const NutsActivityIndicator()),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HomeItemCard(
                      imageUrl: 'assets/images/pending-orders.gif',
                      title: 'Pending Orders',
                      value: recentOrders.when(
                          data: (da) {
                            final states = da.stats;
                            return Text("${states.pendingOrders}");
                          },
                          error: (error, trace) => const Text(''),
                          loading: () => const NutsActivityIndicator()),
                    ),
                    const SizedBox(width: 10),
                    HomeItemCard(
                      imageUrl: 'assets/images/products.gif',
                      title: 'Products',
                      value: recentOrders.when(
                          data: (da) {
                            final states = da.stats;
                            return Text("${states.productCount}");
                          },
                          error: (error, trace) => const Text(''),
                          loading: () => const NutsActivityIndicator()),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                        final recentOrders = data.recentOrders;
                        if (recentOrders.isEmpty) {
                          return const Text('You have no recent orders');
                        }

                        print(
                            "Order for recent${recentOrders[0]['createdAt']}");
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: recentOrders.length,
                            itemBuilder: (context, index) {
                              final List<String> itemNames =
                                  (recentOrders[index]['items']
                                          as List<dynamic>)
                                      .map((item) => item['itemSizeId']
                                          ['itemId']['name'] as String)
                                      .toList();
                              print(recentOrders[index]['vendorStatus']);
                              if (recentOrders.isEmpty) {
                                return const Center(
                                  child: Text('You have no recent orders'),
                                );
                              }
                              return OrderItem(
                                  orderNumber: recentOrders[index]['_id'],
                                  name: recentOrders[index]['customerId']
                                      ['name'],
                                  items: itemNames.join(','),
                                  status: recentOrders[index]['vendorStatus'],
                                  orderDetail: recentOrders[index]['items'],
                                  statusColor: recentOrders[index]
                                              ['vendorStatus'] ==
                                          'PENDING'
                                      ? Colors.yellow
                                      : recentOrders[index]['vendorStatus'] ==
                                              'ACCEPTED'
                                          ? Colors.orange
                                          : recentOrders[index]
                                                      ['vendorStatus'] ==
                                                  'REJECTED'
                                              ? Colors.red
                                              : Colors.green,
                                  createdAt: recentOrders[index]['createdAt']);
                            });
                      },
                      error: (onb, stacktrace) {
                        if (!_isDialogOpen) {
                          _isDialogOpen =
                              true; // Set flag to true when dialog is opened
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (context.mounted) {
                              showErrorDialog(context, () async {
                                if (context.mounted) {
                                  await ref
                                      .read(recentOrdersProvider.notifier)
                                      .fetchRecentOrders();
                                }
                              }, 'Something went wrong while trying to fetch shop details, try again!')
                                  .then((_) {
                                // Reset flag when dialog is closed
                                _isDialogOpen = false;
                              });
                            }
                          });
                        }
                        return const SizedBox
                            .shrink(); // Avoid returning `null`
                      },
                      loading: () => const Center(
                            child: NutsActivityIndicator(),
                          )),
                ),
              ],
// >>>>>>> 48a0b93f71813647cd6fc7410f2675614e671edd
            ),
          )
        ],
      ),
    );
    // );
  }
}
