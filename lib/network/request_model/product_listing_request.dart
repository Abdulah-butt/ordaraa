class ProductListingRequest {
  const ProductListingRequest({
    required this.limit,
    required this.offset,
    this.query,
    this.categoryId,
    this.sellerOrganizationId,
  }) : assert(limit >= 1 && limit <= 100),
       assert(offset >= 0 && offset <= 10000);

  final int limit;
  final int offset;
  final String? query;
  final String? categoryId;
  final String? sellerOrganizationId;

  Map<String, dynamic> toQueryParameters() => {
    'limit': limit,
    'offset': offset,
    if (query != null && query!.trim().isNotEmpty) 'q': query!.trim(),
    if (categoryId != null && categoryId!.isNotEmpty) 'categoryId': categoryId,
    if (sellerOrganizationId != null && sellerOrganizationId!.isNotEmpty)
      'sellerOrganizationId': sellerOrganizationId,
  };
}
