class StoreType {
  final String id;
  final String name;

  StoreType({required this.id, required this.name});

  // Factory constructor to create a StoreType from a JSON object
  factory StoreType.fromJson(Map<String, dynamic> json) {
    return StoreType(
      id: json['_id'],
      name: json['name'],
    );
  }

  // Method to convert a StoreType object back to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class Store {
  final String id;
  final String userId;
  final String storeName;
  final String storePhone;

  final StoreType type; // StoreType object for the nested "type" field
  final DateTime createdAt;

  Store({
    required this.id,
    required this.userId,
    required this.storeName,
    required this.storePhone,
    required this.type,
    required this.createdAt,
  });

  // Factory constructor to create a Store from a JSON object
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['_id'],
      userId: json['userId'],
      storeName: json['storeName'],
      storePhone: json['storePhone'],

      type: StoreType.fromJson(json['type']), // Parse the nested "type"
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Method to convert a Store object back to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'storeName': storeName,
      'storePhone': storePhone,

      'type': type.toJson(), // Convert the StoreType object to JSON
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
