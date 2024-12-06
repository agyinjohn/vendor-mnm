import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/app_colors.dart';
import 'package:mnm_vendor/utils/store_notifier.dart';
import '../utils/selected_store_notifier.dart';

class StoreSelectionPage extends ConsumerWidget {
  const StoreSelectionPage({super.key});
  static const routeName = '/store-selection-page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stores = ref.watch(storeProvider);
    final selectedStore = ref.watch(selectedStoreProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Store'),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: stores.isEmpty
          ? const Center(
              child: Text(
                'No stores available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: stores.length,
                      itemBuilder: (context, index) {
                        final store = stores[index];
                        final isSelected = selectedStore?.id == store.id;

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.grey.shade100,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      store.storeName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Store rating with stars
                                  Row(
                                    children: List.generate(
                                      5,
                                      (starIndex) => Icon(
                                        Icons.star,
                                        size: 18,
                                        color: starIndex < 5
                                            ? Colors.amber
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  'Type: ${store.type.name}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              trailing: Radio<String>(
                                value: store.id,
                                groupValue: selectedStore?.id,
                                activeColor: AppColors.buttonHoverColor,
                                onChanged: (value) {
                                  ref
                                      .read(selectedStoreProvider.notifier)
                                      .selectStore(store);
                                  // Go back after selecting
                                },
                              ),
                              onTap: () {
                                ref
                                    .read(selectedStoreProvider.notifier)
                                    .selectStore(store);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
