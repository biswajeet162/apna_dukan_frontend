/// ProductUpdateRequestDto model
/// Used for updating existing products
class ProductUpdateRequest {
  final String name;
  final String description;
  final double price;
  final double mrp;
  final int categoryId;
  final int stock;
  final List<String> imageUrls;

  ProductUpdateRequest({
    required this.name,
    required this.description,
    required this.price,
    required this.mrp,
    required this.categoryId,
    required this.stock,
    required this.imageUrls,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'mrp': mrp,
      'categoryId': categoryId,
      'stock': stock,
      'imageUrls': imageUrls,
    };
  }
}

