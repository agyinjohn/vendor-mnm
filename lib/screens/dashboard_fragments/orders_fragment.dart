import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../app_colors.dart';
import '../../utils/order_list_data.dart';
// import '../order_list_page.dart';
// import '../utils/order_list_data.dart';
import 'orders_thread/orders_list_initial_page.dart';
import 'orders_thread/orders_list_page.dart';

class OrdersFragment extends StatelessWidget {
  const OrdersFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 26),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderListInitialPage(
                    pageTitle: 'Pending Orders',
                    filterStatus: 'PENDING',
                  ),
                ),
              ),
              child: const OrderContainer(
                color: Colors.yellow,
                title: 'Pending Orders',
                subtitle: 'Orders that are awaiting your confirmation',
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderListInitialPage(
                    filterStatus: 'ACCEPTED',
                    pageTitle: 'Accepted Orders',
                    // orderList: completedOrdersList,
                  ),
                ),
              ),
              child: const OrderContainer(
                color: Colors.orange,
                title: 'Ongoing Orders',
                subtitle: 'Orders that is yet to be completed',
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderListInitialPage(
                    filterStatus: 'COMPLETED',
                    pageTitle: 'Completed Orders',
                    // orderList: completedOrdersList,
                  ),
                ),
              ),
              child: const OrderContainer(
                color: Colors.green,
                title: 'Completed Orders',
                subtitle: 'Orders that have been completed',
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderListInitialPage(
                    pageTitle: 'Rejected Orders',
                    filterStatus: 'REJECTED',
                  ),
                ),
              ),
              child: const OrderContainer(
                color: Colors.red,
                title: 'Rejected Orders',
                subtitle: 'Orders that have been rejected',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderContainer extends StatelessWidget {
  final String title, subtitle;
  final Color color;

  const OrderContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 72,
      width: double.infinity,
      child: Row(
        children: [
          const SizedBox(width: 14),
          CircleAvatar(
            radius: 12,
            backgroundColor: color,
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.start,
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                textAlign: TextAlign.start,
                subtitle,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          const Icon(IconlyLight.arrow_right_2),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}



//import 'package:flutter/material.dart';
// import 'package:iconly/iconly.dart';

// import '../../app_colors.dart';

// class OrdersFragment extends StatelessWidget {
//   const OrdersFragment({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(10.0, 24, 10, 0),
//         child: Center(
//           child: Column(
//             children: [
//               const SizedBox(height: 22),
//               const Text(
//                 'Orders',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               const SizedBox(height: 26),
//               GestureDetector(
//                 onTap: () => Navigator.pushNamed(context, '/order_list_page'),
//                 child: const OrderContainer(
//                     color: Colors.yellow,
//                     title: 'Pending Orders',
//                     subtitle: 'Orders that are awaiting your confirmation'),
//               ),
//               const SizedBox(height: 12),
//               const OrderContainer(
//                   color: Colors.green,
//                   title: 'Completed Orders',
//                   subtitle: 'Orders that are awaiting your confirmation'),
//               const SizedBox(height: 12),
//               GestureDetector(
//                 onTap: () => Navigator.pushNamed(context, '/order_list_page'),
//                 child: const OrderContainer(
//                     color: Colors.red,
//                     title: 'Rejected Orders',
//                     subtitle: 'Orders that are awaiting your confirmation'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class OrderContainer extends StatelessWidget {
//   final String title, subtitle;
//   final Color color;

//   const OrderContainer(
//       {super.key,
//       required this.title,
//       required this.subtitle,
//       required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.cardColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       height: 72,
//       width: double.infinity,
//       child: Row(
//         children: [
//           const SizedBox(width: 14),
//           CircleAvatar(
//             radius: 12,
//             backgroundColor: color,
//           ),
//           const SizedBox(width: 10),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 textAlign: TextAlign.start,
//                 title,
//                 // 'Pending Orders',
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 textAlign: TextAlign.start,
//                 subtitle,
//                 // 'Orders that are awaiting your confirmation',
//                 style: const TextStyle(fontSize: 11),
//               ),
//             ],
//           ),
//           const Spacer(),
//           const Icon(IconlyLight.arrow_right_2),
//           const SizedBox(width: 14),
//         ],
//       ),
//     );
//   }
// }
