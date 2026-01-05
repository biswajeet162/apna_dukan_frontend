/// Category model
class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String? imageUrl;
  final int? parentId;
  final int? level;
  final List<CategoryModel> children;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
    this.parentId,
    this.level,
    this.children = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      parentId: int.tryParse(json['parentId']?.toString() ?? ''),
      level: int.tryParse(json['level']?.toString() ?? ''),
      children: json['children'] is List
          ? (json['children'] as List)
              .map((child) => CategoryModel.fromJson(child is Map ? Map<String, dynamic>.from(child) : {}))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'imageUrl': imageUrl,
      'parentId': parentId,
      'level': level,
      'children': children.map((child) => child.toJson()).toList(),
    };
  }

  /// Flatten the category tree to get all categories in a flat list
  List<CategoryModel> flatten() {
    final List<CategoryModel> result = [this];
    for (final child in children) {
      result.addAll(child.flatten());
    }
    return result;
  }
}

