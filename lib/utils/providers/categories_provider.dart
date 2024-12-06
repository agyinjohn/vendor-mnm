import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../categories_service.dart';

// Create a provider for the CategoriesService
final categoriesServiceProvider = Provider((ref) => CategoriesService());
