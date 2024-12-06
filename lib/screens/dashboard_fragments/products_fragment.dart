import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/screens/upload_product_screen.dart';
import 'package:mnm_vendor/utils/fetch_stores.dart';
import 'package:mnm_vendor/widgets/showsnackbar.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_colors.dart';
import '../../models/food_item.dart';
import '../../providers/store_item_provider.dart';
import '../../utils/food_list.dart';
import '../../utils/selected_store_notifier.dart';

import 'products_thread/product_detail_page.dart';

class ProductsFragment extends ConsumerStatefulWidget {
  const ProductsFragment({super.key});

  @override
  ConsumerState<ProductsFragment> createState() => _ProductsFragmentState();
}

class _ProductsFragmentState extends ConsumerState<ProductsFragment> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final SharedPreferences pref = await SharedPreferences.getInstance();

      final token = pref.getString('token');
      final selectedStoreNotifier = ref.read(selectedStoreProvider.notifier);

      // Assume `stores` is fetched from somewhere else
      // final token = pref.getString('token');
      final stores = await fetchStoresFromApi(token!, context);
      await selectedStoreNotifier.loadSelectedStore(stores);
      final selectedStore = ref.watch(selectedStoreProvider);
      await ref
          .read(storeItemsProvider.notifier)
          .fetchStoreItems(selectedStore!.id);
    } catch (e) {
      showCustomSnackbar(
          context: context,
          message: 'Something went wrong',
          action: SnackBarAction(label: 'Refresh', onPressed: () {}));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeItems = ref.watch(storeItemsProvider);
    print(storeItems);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? const Center(
              child: NutsActivityIndicator(),
            )
          : storeItems.isEmpty
              ? const Center(
                  child:
                      Text('No Products available in selected store category'),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size.width < 600
                        ? 2
                        : 4, // Adjusts columns based on screen size
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.70, // Adjust height-to-width ratio
                  ),
                  itemCount: storeItems.length,
                  itemBuilder: (context, index) {
                    final item = storeItems[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                      item: item,
                                    )));
                      },
                      child: FoodItem(
                        imageUrl: "${AppColors.url}${item.images[0].url}",
                        description: item.description,
                        price: '...',
                        rating: '4.5',
                        quantity: item.quantity,
                      ),
                    );
                  },
                ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UploadProductScreen()));
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange.withOpacity(0.9),
          ),
          height: 50,
          width: 50,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Colors.white),
                Text(
                  'Add',
                  style: TextStyle(
                      color: Colors.white, fontSize: size.width * 0.023),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
