/// Paginated response wrapper
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
}

