// ignore_for_file: public_member_api_docs, sort_constructors_first

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

class Ratings {
  final int totalPeopleRated;
  final int totalRatedValue;
  final int totalRatedPoint;

  Ratings({
    required this.totalPeopleRated,
    required this.totalRatedValue,
    required this.totalRatedPoint,
  });

  // Factory constructor to create a Ratings instance from a JSON map
  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
      totalPeopleRated: json['totalPeopleRated'],
      totalRatedValue: json['totalRatedValue'],
      totalRatedPoint: json['totalRatedPoint'],
    );
  }

  // Method to convert a Ratings instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'totalPeopleRated': totalPeopleRated,
      'totalRatedValue': totalRatedValue,
      'totalRatedPoint': totalRatedPoint,
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  // Factory constructor to create a Location instance from a JSON map
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates']),
    );
  }

  // Method to convert a Location instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class Store {
  final String id;
  final String userId;
  final String storeName;
  final String storePhone;
  final String storeAddress;
  final Location location;
  final Ratings ratings;
  final StoreType type; // StoreType object for the nested "type" field
  final DateTime createdAt;
  final List<dynamic> images;
  final int startTime;
  final int endTime;
  final bool isOpened;
  Store({
    required this.id,
    required this.location,
    required this.ratings,
    required this.userId,
    required this.storeName,
    required this.storePhone,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.storeAddress,
    required this.createdAt,
    required this.images,
    required this.isOpened,
  });

  // Factory constructor to create a Store from a JSON object
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['_id'],
      isOpened: json['open'],
      userId: json['userId'],
      storeName: json['storeName'],
      storePhone: json['storePhone'],
      storeAddress: json['storeAddress'],
      type: StoreType.fromJson(json['type']), // Parse the nested "type"
      location: Location.fromJson(json['location']),
      ratings: Ratings.fromJson(json['ratings']),
      images: json['images'],
      endTime: json['endTime'],
      startTime: json['startTime'],
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
      'images': images,
      "location": location.toJson(),
      "ratings": ratings.toJson(),
      "storeAddress": storeAddress,
      "startTime": startTime,
      "endTime": endTime,
      "open": isOpened,
      'type': type.toJson(), // Convert the StoreType object to JSON
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
