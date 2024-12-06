class StoreItem {
  final String id;
  final String storeId;
  final String name;
  final String description;
  final List<ImageModel> images;
  final int quantity;
  final bool enable;
  final List<ItemSize> itemSizes;
  final Map<String, dynamic> attributes;

  StoreItem({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.enable,
    required this.itemSizes,
    required this.attributes,
    required this.images,
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['_id'],
      storeId: json['storeId'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
      enable: json['enable'],
      images: (json['images'] as List)
          .map((image) => ImageModel.fromJson(image))
          .toList(),
      itemSizes: List<ItemSize>.from(
          json['itemSizes'].map((x) => ItemSize.fromJson(x))),
      attributes: json['attributes'] ?? {},
    );
  }
}

class ItemSize {
  final String id;
  final String name;
  final double price;
  final bool enable;

  ItemSize({
    required this.id,
    required this.name,
    required this.price,
    required this.enable,
  });

  factory ItemSize.fromJson(Map<String, dynamic> json) {
    return ItemSize(
      id: json['_id'],
      name: json['name'],
      price: json['price'].toDouble(),
      enable: json['enable'],
    );
  }
}

class ImageModel {
  final String id;
  final String url;

  ImageModel({
    required this.id,
    required this.url,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['_id'],
      url: json['url'],
    );
  }
}
