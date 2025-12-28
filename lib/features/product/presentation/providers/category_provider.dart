import 'package:flutter/foundation.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/models/category_model.dart';

/// Provider for category state management
class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository;

  CategoryProvider(this._repository);

  List<CategoryModel> _categories = [];
  List<CategoryModel> _flatCategories = [];
  CategoryModel? _selectedCategory;
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get flatCategories => _flatCategories;
  CategoryModel? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all categories
  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _repository.getAllCategories();
      // Flatten the tree to get all categories for the sidebar
      // Keep only top-level categories and their direct children
      _flatCategories = _categories.expand((cat) {
        final list = [cat];
        list.addAll(cat.children);
        return list;
      }).toList();
      
      // Select first category by default
      if (_flatCategories.isNotEmpty && _selectedCategory == null) {
        _selectedCategory = _flatCategories.first;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Select a category
  void selectCategory(CategoryModel category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Get child categories for a parent
  Future<List<CategoryModel>> getCategoryChildren(int categoryId) async {
    try {
      return await _repository.getCategoryChildren(categoryId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }
}

