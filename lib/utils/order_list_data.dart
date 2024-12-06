import 'package:flutter/material.dart';

import '../screens/dashboard_fragments/orders_thread/order_detail.page.dart';
import '../screens/dashboard_fragments/orders_thread/orders_list_initial_page.dart';
import '../widgets/order_item.dart';

List<OrderItem> pendingOrdersList = List.generate(
  20,
  (index) => const OrderItem(
      createdAt: 'last year',
      items: '1x Fries, 1x Coca Cola, 2x Coconut Bread',
      name: 'Mohammed Ali',
      orderNumber: '12345',
      status: 'Awaiting confirmation',
      statusColor: Colors.yellow),
);

List<OrderItem> completedOrdersList = List.generate(
  20,
  (index) => const OrderItem(
    createdAt: 'last year',
    items: '1x Fries, 1x Coca Cola, 2x Coconut Bread',
    name: 'Jane Smith',
    orderNumber: '12345',
    status: 'Order completed',
    statusColor: Colors.green,
  ),
);

List<OrderItem> rejectedOrdersList = List.generate(
  20,
  (index) => const OrderItem(
    createdAt: 'last year',
    items: '1x Fries, 1x Coca Cola, 2x Coconut Bread',
    name: 'Name',
    orderNumber: '12345',
    status: 'Order rejected',
    statusColor: Colors.red,
  ),
);

List<CustomCard> completedOrdersByDate = const [
  CustomCard(date: 'Saturday, Aug 10, 2024'),
  CustomCard(date: 'Sunday, Aug 11, 2024'),
  CustomCard(date: 'Monday, Aug 12, 2024'),
  CustomCard(date: 'Tuesday, Aug 13, 2024'),
  CustomCard(date: 'Wednesday, Aug 14, 2024'),
  CustomCard(date: 'Thursday, Aug 15, 2024'),
  CustomCard(date: 'Friday, Aug 16, 2024'),
  CustomCard(date: 'Saturday, Aug 17, 2024'),
  CustomCard(date: 'Sunday, Aug 18, 2024'),
  CustomCard(date: 'Monday, Aug 19, 2024'),
  CustomCard(date: 'Tuesday, Aug 20, 2024'),
  CustomCard(date: 'Wednesday, Aug 21, 2024'),
  CustomCard(date: 'Thursday, Aug 22, 2024'),
  CustomCard(date: 'Friday, Aug 23, 2024'),
  CustomCard(date: 'Saturday, Aug 24, 2024'),
  CustomCard(date: 'Sunday, Aug 25, 2024'),
  CustomCard(date: 'Monday, Aug 26, 2024'),
  CustomCard(date: 'Tuesday, Aug 27, 2024'),
  CustomCard(date: 'Wednesday, Aug 28, 2024'),
  CustomCard(date: 'Thursday, Aug 29, 2024'),
  CustomCard(date: 'Friday, Aug 30, 2024'),
];

// List<OrderItemDetail> orderItemDetailList = const [];
