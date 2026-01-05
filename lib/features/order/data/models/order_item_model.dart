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
      productId: int.tryParse(json['productId']?.toString() ?? '') ?? 0,
      productName: json['productName']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      mrp: double.tryParse(json['mrp']?.toString() ?? '') ?? 0.0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '') ?? 0.0,
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

