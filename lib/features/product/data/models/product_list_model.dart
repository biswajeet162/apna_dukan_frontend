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
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      mrp: double.tryParse(json['mrp']?.toString() ?? '') ?? 0.0,
      discountPercentage: double.tryParse(json['discountPercentage']?.toString() ?? '') ?? 0.0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0.0,
      stockAvailable: json['stockAvailable'] == true,
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

