import 'package:flutter/foundation.dart';
import '../../data/repositories/order_repository.dart';

/// Order provider
class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository;

  OrderProvider(this._repository);

  // TODO: Implement order state management

  void clearData() {
    // TODO: Clear order data
    notifyListeners();
  }
}

