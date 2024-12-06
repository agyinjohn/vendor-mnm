import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:mnm_vendor/app_colors.dart';
import 'package:mnm_vendor/models/categories_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesService {
  static const String baseUrl = '${AppColors.url}/auth/item-categories';

  Future<List<dynamic>> fetchCategories() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final String? token = sharedPreferences
        .getString('token'); // Replace this with your token logic
    print(token);
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print(response);
    if (response.statusCode == 200) {
      // List<dynamic> categories = jsonDecode(response.body);
      // // Extract the category names from the map
      // return categories
      //     .map<String>((category) => category['name'] as String)
      //     .toList(); // Return the decoded categories
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
