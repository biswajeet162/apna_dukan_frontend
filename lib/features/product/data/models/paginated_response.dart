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
    dynamic json,
    T Function(dynamic) fromJsonT,
  ) {
    final Map<String, dynamic> safeJson = <String, dynamic>{};
    if (json is Map) {
      json.forEach((key, value) {
        safeJson[key.toString()] = value;
      });
    }

    final content = safeJson['content'] is List
        ? (safeJson['content'] as List).map((item) => fromJsonT(item)).toList().cast<T>()
        : <T>[];

    return PaginatedResponse<T>(
      content: content,
      totalElements: int.tryParse(safeJson['totalElements']?.toString() ?? '') ?? 0,
      totalPages: int.tryParse(safeJson['totalPages']?.toString() ?? '') ?? 0,
      currentPage: int.tryParse(safeJson['number']?.toString() ?? '') ?? 0,
      size: int.tryParse(safeJson['size']?.toString() ?? '') ?? 0,
      hasNext: safeJson['hasNext'] == true,
      hasPrevious: safeJson['hasPrevious'] == true,
    );
  }
}
