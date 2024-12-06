import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mnm_vendor/app_colors.dart';
import 'package:mnm_vendor/utils/formated_date.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderNumber, customerName, createdAt;
  final List<dynamic> itemDetail;

  const OrderDetailPage({
    super.key,
    required this.orderNumber,
    required this.customerName,
    this.itemDetail = const [],
    this.createdAt = '',
  });

  @override
  Widget build(BuildContext context) {
    print(itemDetail);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(IconlyLight.arrow_left_2)),
              ),
              const SizedBox(width: 3),
            ],
          ),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.call))],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const Icon(IconlyBroken.paper, size: 70),
                    // const SizedBox(width: 1),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order No.:'),
                        Text('Customer:'),
                        Text('Order No.:'),
                      ],
                    ),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#$orderNumber',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          customerName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Ayeduase Gate',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.black, thickness: 4),
              const SizedBox(height: 8),
              ...itemDetail.map((item) {
                return Column(
                  children: [
                    OrderItemDetail(
                        ordercost: item['orderCost'].toString(),
                        attributes: item['attributes'],
                        size: item['itemSizeId']['name'],
                        item: item['itemSizeId']['itemId']['name'] as String,
                        description:
                            item['itemSizeId']['itemId']['name'] as String,
                        quantity: item['quantity'].toString()),
                    const Divider(color: AppColors.cardColor, thickness: 2),
                    const SizedBox(height: 8),
                  ],
                );
              }),
              const Row(
                children: [
                  Icon(IconlyBroken.profile),
                  SizedBox(width: 8),
                  Text(
                    'Customer Personal Preferences',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: AppColors.cardColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(formatDateTime(createdAt)),
              const SizedBox(
                height: 14,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OrderItemDetail extends StatelessWidget {
  final String item, description, quantity, size, ordercost;
  final List<dynamic> attributes;
  const OrderItemDetail(
      {super.key,
      required this.item,
      required this.description,
      this.ordercost = '',
      this.attributes = const [],
      this.size = '',
      required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(IconlyBroken.paper),
        const SizedBox(width: 10),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item,
                // ,
                style: const TextStyle(
                    color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Text(
                    'Desc.: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(description),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Extras: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    attributes
                        .map((atr) => '${atr['name']}-GHS${atr['price']}')
                        .join(', '), // Join the strings with a comma
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Spacer(),
                  const Text(
                    'Size: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    overflow: TextOverflow.fade,
                    // textAlign: TextAlign.end,
                    size,
                    style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Spacer(),
                  const Text(
                    'Quantity: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    overflow: TextOverflow.fade,
                    // textAlign: TextAlign.end,
                    quantity,
                    style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 150,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Total:GHS$ordercost',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
