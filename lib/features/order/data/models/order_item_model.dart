/// Order item model representing a product in an order
class OrderItemModel {
  final int productId;
  final String productName;
  final String imageUrl;
  final double price;
  final double mrp;
  final int quantity;
  final double subtotal;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.mrp,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId']?.toInt() ?? 0,
      productName: json['productName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      mrp: (json['mrp'] ?? 0.0).toDouble(),
      quantity: json['quantity']?.toInt() ?? 0,
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'price': price,
      'mrp': mrp,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}

