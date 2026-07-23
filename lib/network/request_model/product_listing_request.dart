class ProductListingRequest {
  const ProductListingRequest({
    required this.limit,
    this.cursor,
    this.query,
    this.categoryId,
    this.sellerOrganizationId,
  }) : assert(limit >= 1 && limit <= 100);

  final int limit;
  final String? cursor;
  final String? query;
  final String? categoryId;
  final String? sellerOrganizationId;

  Map<String, dynamic> toQueryParameters() => {
    'limit': limit,
    if (cursor != null && cursor!.isNotEmpty) 'cursor': cursor,
    if (query != null && query!.trim().isNotEmpty) 'q': query!.trim(),
    if (categoryId != null && categoryId!.isNotEmpty) 'categoryId': categoryId,
    if (sellerOrganizationId != null && sellerOrganizationId!.isNotEmpty)
      'sellerOrganizationId': sellerOrganizationId,
  };
}
