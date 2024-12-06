class SubCategoryModel {
  final String id;
  final String name;

  SubCategoryModel({
    required this.id,
    required this.name,
  });

  // Factory method to create a SubCategoryModel from a JSON object
  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final bool enabled;
  final List<SubCategoryModel> subCategories;

  CategoryModel({
    required this.id,
    required this.name,
    required this.enabled,
    required this.subCategories,
  });

  // Factory method to create a CategoryModel from a JSON object
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'],
      enabled: json['enable'],
      name: json['name'],
      subCategories: (json['subCategories'] as List)
          .map((subCat) => SubCategoryModel.fromJson(subCat))
          .toList(),
    );
  }
}
