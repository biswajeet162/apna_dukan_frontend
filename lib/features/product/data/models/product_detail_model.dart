/// ProductDetailResponseDto model
/// Used for displaying full product details
class ProductDetailModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final double mrp;
  final double discountPercentage;
  final List<String> imageUrls;
  final int categoryId;
  final String categoryName;
  final int stock;
  final double rating;
  final int reviewsCount;

  ProductDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.mrp,
    required this.discountPercentage,
    required this.imageUrls,
    required this.categoryId,
    required this.categoryName,
    required this.stock,
    required this.rating,
    required this.reviewsCount,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    // Safely parse imageUrls - ensure it's a proper List<String>
    List<String> parsedImageUrls = <String>[];
    if (json['imageUrls'] != null) {
      if (json['imageUrls'] is List) {
        try {
          // Explicitly convert each item to String to avoid type errors in Flutter Web
          final List<dynamic> rawList = json['imageUrls'] as List<dynamic>;
          parsedImageUrls = rawList.map((item) {
            if (item == null) return '';
            return item.toString();
          }).toList();
        } catch (e) {
          // If conversion fails, use empty list
          parsedImageUrls = <String>[];
        }
      }
    }

    return ProductDetailModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: _parseDouble(json['price']),
      mrp: _parseDouble(json['mrp']),
      discountPercentage: _parseDouble(json['discountPercentage']),
      imageUrls: parsedImageUrls,
      categoryId: _parseInt(json['categoryId']),
      categoryName: json['categoryName']?.toString() ?? '',
      stock: _parseInt(json['stock']),
      rating: _parseDouble(json['rating']),
      reviewsCount: _parseInt(json['reviewsCount']),
    );
  }

  // Helper methods for safe parsing to avoid type errors in Flutter Web
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    final parsed = int.tryParse(value.toString());
    return parsed ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    final parsed = double.tryParse(value.toString());
    return parsed ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'mrp': mrp,
      'discountPercentage': discountPercentage,
      'imageUrls': imageUrls,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'stock': stock,
      'rating': rating,
      'reviewsCount': reviewsCount,
    };
  }
}

