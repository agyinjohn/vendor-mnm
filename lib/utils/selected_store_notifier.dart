import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/models/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedStoreNotifier extends StateNotifier<Store?> {
  SelectedStoreNotifier() : super(null);

  // Load selected store from SharedPreferences
  Future<void> loadSelectedStore(List<Store> stores) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedStoreId = prefs.getString('selectedStoreId');

    // If a store is already selected, set it as the state
    if (selectedStoreId != null) {
      state = stores.firstWhere((store) => store.id == selectedStoreId,
          orElse: () => stores.first);
    } else {
      // If no store found, select the first one
      state = stores.isNotEmpty ? stores.first : null;
    }
  }

  // Save selected store to SharedPreferences
  Future<void> selectStore(Store store) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedStoreId', store.id);
    state = store;
  }
}

final selectedStoreProvider =
    StateNotifierProvider<SelectedStoreNotifier, Store?>((ref) {
  return SelectedStoreNotifier();
});
