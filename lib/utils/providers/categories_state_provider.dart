import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnm_vendor/utils/providers/categories_provider.dart';

// Create a state provider that fetches categories
final categoriesProvider = FutureProvider<List<dynamic>>((ref) async {
  final categoriesService = ref.read(categoriesServiceProvider);
  return categoriesService.fetchCategories();
});
