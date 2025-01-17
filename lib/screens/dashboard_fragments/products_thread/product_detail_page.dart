import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mnm_vendor/models/store_item.dart';

import '../../../app_colors.dart';
import 'upload_food_screen.dart';
// import '../../upload_product_screen.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.item});
  final StoreItem item;
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<String> _images = [
    'assets/images/kfc 2.png',
    'assets/images/kelewele 1.png',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(widget.item.attributes);
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            leading: Padding(
              padding: EdgeInsets.only(left: size.width * 0.03),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    const Icon(
                      IconlyLight.arrow_left_2,
                      size: 18,
                    ),
                    Text(
                      ' Back',
                      style: TextStyle(fontSize: size.width * 0.03),
                    ),
                  ],
                ),
              ),
            ),
            centerTitle: true,
            title: const Text(
              'Product Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: size.width * 0.06),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UploadFoodScreen()));
                  },
                  child: Row(
                    children: [
                      const Icon(IconlyLight.edit,
                          size: 18, color: AppColors.primaryColor),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: size.width * 0.03,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: size.width * 0.026,
              horizontal: size.height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.item.images.length,
                        onPageChanged: (int index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              "${AppColors.url}${widget.item.images[index].url}",
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    // Left navigation button
                    if (_currentIndex > 0)
                      Positioned(
                        left: 10,
                        top: size.height * 0.15,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.grey[100]!.withOpacity(0.6),
                          ),
                          width: size.width * 0.08,
                          height: size.height * 0.10,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                              ),
                              color: Colors.black,
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    // Right navigation button
                    if (_currentIndex < widget.item.images.length - 1)
                      Positioned(
                        right: 10,
                        top: size.height * 0.15,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.grey[100]!.withOpacity(0.6),
                          ),
                          width: size.width * 0.08,
                          height: size.height * 0.10,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              color: Colors.black,
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: size.height * 0.008),

                // Page Indicator
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.item.images.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? AppColors.primaryColor
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.024),
                const Text(
                  'Product Name',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: size.height * 0.008),
                Text(
                  widget.item.name,
                  style: const TextStyle(fontSize: 12),
                ),
                SizedBox(height: size.height * 0.024),
                const Text(
                  'Product Description',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: size.height * 0.008),
                Text(
                  widget.item.description,
                  style: const TextStyle(fontSize: 12),
                ),
                SizedBox(height: size.height * 0.024),
                const Text(
                  'Prices',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: size.height * 0.008),
                ...widget.item.itemSizes
                    .map((e) => widget.item.itemSizes.length < 2
                        ? Text(
                            'GHS ${e.price.toString()}',
                            style: const TextStyle(fontSize: 12),
                          )
                        : _buildPriceCard(context, e.name, e.price.toString())),
                SizedBox(height: size.height * 0.024),

                if (widget.item.attributes.containsKey('Add-ons')) ...[
                  const Text('Addons',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.item.attributes['Add-ons']!.length,
                    itemBuilder: (context, index) {
                      final addons = widget.item.attributes['Add-ons'][index];
                      return _buildPriceCard(
                          context, addons['name'], addons['price']);
                    },
                  )
                  // ...widget.item.attributes
                  // _buildPriceCard(context, 'Small', '50.00'),
                  // _buildPriceCard(context, 'Medium', '70.00'),
                  // _buildPriceCard(context, 'Large', '90.00'),
                ],
              ],
            ),
          ),
        ));
  }

  Widget _buildPriceCard(BuildContext context, String itemSize, String price) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.width * 0.016,
        horizontal: 0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300],
        ),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.022),
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.26,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Size',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      itemSize,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(width: size.width * 0.024),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    'GHC $price',
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(right: size.width * 0.022),
                child: IconButton(
                  icon: const Icon(IconlyLight.show, size: 18),
                  // color: Colors.red),
                  onPressed: () {},
                  // => removePriceEntry(index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
