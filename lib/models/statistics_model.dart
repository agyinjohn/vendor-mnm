class Stats {
  final int completedOrders;
  final int pendingOrders;
  final int productCount;
  final double revenue;

  Stats({
    required this.completedOrders,
    required this.pendingOrders,
    required this.productCount,
    required this.revenue,
  });

  // Factory constructor to create a Stats object from JSON
  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      completedOrders: json['completedOrders'] ?? 0,
      pendingOrders: json['pendingOrders'] ?? 0,
      productCount: json['productCount'] ?? 0,
      revenue: (json['revenue'] ?? 0).toDouble(),
    );
  }

  // Method to convert a Stats object to JSON
  Map<String, dynamic> toJson() {
    return {
      'completedOrders': completedOrders,
      'pendingOrders': pendingOrders,
      'productCount': productCount,
      'revenue': revenue,
    };
  }
}
