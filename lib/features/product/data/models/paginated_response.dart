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
    final content = (json['content'] as List<dynamic>?)
            ?.map((item) => fromJsonT(item))
            .toList() ??
        [];

    return PaginatedResponse<T>(
      content: content,
      totalElements: json['totalElements']?.toInt() ?? 0,
      totalPages: json['totalPages']?.toInt() ?? 0,
      currentPage: json['number']?.toInt() ?? 0,
      size: json['size']?.toInt() ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrevious: json['hasPrevious'] ?? false,
    );
  }
}

