import 'order_item_model.dart';

/// Order status enum
enum OrderStatus {
  placed,
  confirmed,
  processing,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
  returned;

  static OrderStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'PLACED':
        return OrderStatus.placed;
      case 'CONFIRMED':
        return OrderStatus.confirmed;
      case 'PROCESSING':
        return OrderStatus.processing;
      case 'SHIPPED':
        return OrderStatus.shipped;
      case 'OUT_FOR_DELIVERY':
        return OrderStatus.outForDelivery;
      case 'DELIVERED':
        return OrderStatus.delivered;
      case 'CANCELLED':
        return OrderStatus.cancelled;
      case 'RETURNED':
        return OrderStatus.returned;
      default:
        return OrderStatus.placed;
    }
  }

  String get displayName {
    switch (this) {
      case OrderStatus.placed:
        return 'Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
    }
  }

  String get value {
    switch (this) {
      case OrderStatus.placed:
        return 'PLACED';
      case OrderStatus.confirmed:
        return 'CONFIRMED';
      case OrderStatus.processing:
        return 'PROCESSING';
      case OrderStatus.shipped:
        return 'SHIPPED';
      case OrderStatus.outForDelivery:
        return 'OUT_FOR_DELIVERY';
      case OrderStatus.delivered:
        return 'DELIVERED';
      case OrderStatus.cancelled:
        return 'CANCELLED';
      case OrderStatus.returned:
        return 'RETURNED';
    }
  }
}

/// Payment status enum
enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded;

  static PaymentStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return PaymentStatus.pending;
      case 'PAID':
        return PaymentStatus.paid;
      case 'FAILED':
        return PaymentStatus.failed;
      case 'REFUNDED':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }
}

/// Delivery address model
class DeliveryAddress {
  final String name;
  final String phone;
  final String addressLine;
  final String pincode;

  DeliveryAddress({
    required this.name,
    required this.phone,
    required this.addressLine,
    required this.pincode,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      addressLine: json['addressLine'] ?? '',
      pincode: json['pincode'] ?? '',
    );
  }
}

/// Price details model
class PriceDetails {
  final double totalMrp;
  final double discount;
  final double deliveryCharge;
  final double payableAmount;

  PriceDetails({
    required this.totalMrp,
    required this.discount,
    required this.deliveryCharge,
    required this.payableAmount,
  });

  factory PriceDetails.fromJson(Map<String, dynamic> json) {
    return PriceDetails(
      totalMrp: (json['totalMrp'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      deliveryCharge: (json['deliveryCharge'] ?? 0.0).toDouble(),
      payableAmount: (json['payableAmount'] ?? 0.0).toDouble(),
    );
  }
}

/// Order list item model (for order history)
class OrderListModel {
  final int orderId;
  final String orderNumber;
  final OrderStatus orderStatus;
  final DateTime placedAt;
  final double totalAmount;
  final int totalItems;

  OrderListModel({
    required this.orderId,
    required this.orderNumber,
    required this.orderStatus,
    required this.placedAt,
    required this.totalAmount,
    required this.totalItems,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) {
    return OrderListModel(
      orderId: json['orderId']?.toInt() ?? 0,
      orderNumber: json['orderNumber'] ?? '',
      orderStatus: OrderStatus.fromString(json['orderStatus'] ?? 'PLACED'),
      placedAt: DateTime.parse(json['placedAt'] ?? DateTime.now().toIso8601String()),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      totalItems: json['totalItems']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderNumber': orderNumber,
      'orderStatus': orderStatus.value,
      'placedAt': placedAt.toIso8601String(),
      'totalAmount': totalAmount,
      'totalItems': totalItems,
    };
  }
}

/// Order detail model (full order information)
class OrderDetailModel {
  final int orderId;
  final String orderNumber;
  final OrderStatus orderStatus;
  final PaymentStatus paymentStatus;
  final DateTime placedAt;
  final DateTime? deliveredAt;
  final DeliveryAddress deliveryAddress;
  final PriceDetails priceDetails;
  final List<OrderItemModel> items;

  OrderDetailModel({
    required this.orderId,
    required this.orderNumber,
    required this.orderStatus,
    required this.paymentStatus,
    required this.placedAt,
    this.deliveredAt,
    required this.deliveryAddress,
    required this.priceDetails,
    required this.items,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      orderId: json['orderId']?.toInt() ?? 0,
      orderNumber: json['orderNumber'] ?? '',
      orderStatus: OrderStatus.fromString(json['orderStatus'] ?? 'PLACED'),
      paymentStatus: PaymentStatus.fromString(json['paymentStatus'] ?? 'PENDING'),
      placedAt: DateTime.parse(json['placedAt'] ?? DateTime.now().toIso8601String()),
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'])
          : null,
      deliveryAddress: DeliveryAddress.fromJson(json['deliveryAddress'] != null ? Map<String, dynamic>.from(json['deliveryAddress'] as Map) : {}),
      priceDetails: PriceDetails.fromJson(json['priceDetails'] != null ? Map<String, dynamic>.from(json['priceDetails'] as Map) : {}),
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderNumber': orderNumber,
      'orderStatus': orderStatus.value,
      'paymentStatus': paymentStatus.name.toUpperCase(),
      'placedAt': placedAt.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'deliveryAddress': deliveryAddress,
      'priceDetails': priceDetails,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

