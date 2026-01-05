/// Paginated response wrapper for product lists
class PaginatedResponse<T> {
  final List<T> content;
  final int totalElements;
  final int totalPages;
  final int currentPage;
  final int size;
  final bool hasNext;
  final bool hasPrevious;

  PaginatedResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
    required this.size,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    final content = json['content'] is List
        ? (json['content'] as List).map((item) => fromJsonT(item)).toList().cast<T>()
        : <T>[];

    return PaginatedResponse<T>(
      content: content,
      totalElements: int.tryParse(json['totalElements']?.toString() ?? '') ?? 0,
      totalPages: int.tryParse(json['totalPages']?.toString() ?? '') ?? 0,
      currentPage: int.tryParse(json['number']?.toString() ?? '') ?? 0,
      size: int.tryParse(json['size']?.toString() ?? '') ?? 0,
      hasNext: json['hasNext'] == true,
      hasPrevious: json['hasPrevious'] == true,
    );
  }
}

