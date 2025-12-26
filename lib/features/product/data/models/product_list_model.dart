/// ProductListResponseDto model
/// Used for displaying products in lists/grids
class ProductListModel {
  final int id;
  final String name;
  final double price;
  final double mrp;
  final double discountPercentage;
  final String imageUrl;
  final double rating;
  final bool stockAvailable;

  ProductListModel({
    required this.id,
    required this.name,
    required this.price,
    required this.mrp,
    required this.discountPercentage,
    required this.imageUrl,
    required this.rating,
    required this.stockAvailable,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) {
    return ProductListModel(
      id: json['id']?.toInt() ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      mrp: (json['mrp'] ?? 0.0).toDouble(),
      discountPercentage: (json['discountPercentage'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      stockAvailable: json['stockAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'mrp': mrp,
      'discountPercentage': discountPercentage,
      'imageUrl': imageUrl,
      'rating': rating,
      'stockAvailable': stockAvailable,
    };
  }
}

