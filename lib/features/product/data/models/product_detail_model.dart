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
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      mrp: double.tryParse(json['mrp']?.toString() ?? '') ?? 0.0,
      discountPercentage: double.tryParse(json['discountPercentage']?.toString() ?? '') ?? 0.0,
      imageUrls: json['imageUrls'] is List
          ? List<String>.from((json['imageUrls'] as List).map((e) => e.toString()))
          : <String>[],
      categoryId: int.tryParse(json['categoryId']?.toString() ?? '') ?? 0,
      categoryName: json['categoryName']?.toString() ?? '',
      stock: int.tryParse(json['stock']?.toString() ?? '') ?? 0,
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0.0,
      reviewsCount: int.tryParse(json['reviewsCount']?.toString() ?? '') ?? 0,
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

