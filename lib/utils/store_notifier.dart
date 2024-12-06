import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/utils/fetch_stores.dart';

import '../models/store.dart';

class StoreNotifier extends StateNotifier<List<Store>> {
  StoreNotifier() : super([]);

  Future<void> fetchStores(String token, BuildContext context) async {
    print(token);
    state = await fetchStoresFromApi(token, context);
  }
}

final storeProvider = StateNotifierProvider<StoreNotifier, List<Store>>((ref) {
  return StoreNotifier();
});
