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
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      imageUrl: json['imageUrl'] as String?,
      parentId: json['parentId'] as int?,
      level: json['level'] as int?,
      children: (json['children'] as List<dynamic>?)
              ?.map((child) => CategoryModel.fromJson(child as Map<String, dynamic>))
              .toList() ??
          [],
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

