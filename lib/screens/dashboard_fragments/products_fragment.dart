import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/screens/upload_product_screen.dart';
import 'package:mnm_vendor/upload_pages/upload_beverage_screen.dart';
import 'package:mnm_vendor/upload_pages/upload_drug_page.dart';
import 'package:mnm_vendor/upload_pages/upload_food_screen.dart';
import 'package:mnm_vendor/utils/fetch_stores.dart';
import 'package:mnm_vendor/widgets/showsnackbar.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_colors.dart';
import '../../models/food_item.dart';
import '../../providers/store_item_provider.dart';
import '../../upload_pages/upload_gift_screen.dart';
import '../../utils/food_list.dart';
import '../../utils/selected_store_notifier.dart';

import 'products_thread/product_detail_page.dart';

class ProductsFragment extends ConsumerStatefulWidget {
  const ProductsFragment({super.key});

  @override
  ConsumerState<ProductsFragment> createState() => _ProductsFragmentState();
}

class _ProductsFragmentState extends ConsumerState<ProductsFragment> {
  bool isLoading = false; // Indicates the initial load
  bool isUpdating = false; // Indicates background updates

  @override
  void initState() {
    super.initState();
    getData(initialLoad: true); // Initial data load
  }

  getData({bool initialLoad = false}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    const maxRetries = 4;
    int attempt = 0;

    if (initialLoad) {
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isUpdating = true; // Background update indicator
      });
    }

    while (attempt < maxRetries) {
      try {
        final token = pref.getString('token');
        if (token == null) {
          throw Exception('Token is missing');
        }

        final stores = await fetchStoresFromApi(token, context);
        final selectedStoreNotifier = ref.read(selectedStoreProvider.notifier);
        await selectedStoreNotifier.loadSelectedStore(stores);

        final selectedStore = ref.watch(selectedStoreProvider);
        if (selectedStore == null) {
          throw Exception('No selected store found');
        }

        await ref
            .read(storeItemsProvider.notifier)
            .fetchStoreItems(selectedStore.id);

        // Exit the loop if successful
        break;
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          showCustomSnackbar(
            context: context,
            message: 'Failed to load data',
            action: SnackBarAction(
                label: 'Refresh',
                onPressed: () async {
                  await getData(initialLoad: false);
                }),
            duration: const Duration(seconds: 10),
          );
        }
      } finally {
        if (initialLoad) {
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isUpdating = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeItems = ref.watch(storeItemsProvider);
    final size = MediaQuery.of(context).size;
    final selectedStore = ref.watch(selectedStoreProvider);
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          storeItems.isEmpty && !isLoading
              ? const Center(
                  child:
                      Text('No Products available in selected store category'),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size.width < 600 ? 2 : 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.70,
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
                        price: item.itemSizes.length < 2
                            ? item.itemSizes.map((i) => i.price).join('')
                            : '...',
                        rating: '4.5',
                        quantity: item.quantity,
                      ),
                    );
                  },
                ),

          // Loading indicator for initial load
          if (isLoading)
            const Center(
              child: NutsActivityIndicator(),
            ),

          // Small indicator for background updates
          if (isUpdating)
            const Positioned(
              bottom: 16,
              right: 16,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.orange,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 2,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                if (selectedStore!.type.name == 'fast food & beverages') {
                  return const UploadFoodScreen();
                } else if (selectedStore.type.name == 'gift packages') {
                  return const UploadGiftScreen();
                } else if (selectedStore.type.name == 'pharmacy') {
                  return const UploadDrugScreen();
                } else {
                  // Fallback screen if none of the conditions match
                  return const UploadBeverageScreen();
                }
              },
            ),
          );
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
