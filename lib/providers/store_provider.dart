import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/models/store.dart';

class StoreNotifier extends StateNotifier<Store?> {
  StoreNotifier() : super(null);

  // Method to select a store
  void selectStore(Store store) {
    state = store;
  }

  // Method to clear the selection
  void clearSelection() {
    state = null;
  }
}

// Provide the selected store
final selectedStoreProvider =
    StateNotifierProvider<StoreNotifier, Store?>((ref) {
  return StoreNotifier();
});
