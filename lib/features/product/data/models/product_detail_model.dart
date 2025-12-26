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
    return ProductDetailModel(
      id: json['id']?.toInt() ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      mrp: (json['mrp'] ?? 0.0).toDouble(),
      discountPercentage: (json['discountPercentage'] ?? 0.0).toDouble(),
      imageUrls: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'])
          : [],
      categoryId: json['categoryId']?.toInt() ?? 0,
      categoryName: json['categoryName'] ?? '',
      stock: json['stock']?.toInt() ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewsCount: json['reviewsCount']?.toInt() ?? 0,
    );
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

