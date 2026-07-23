import '../../core/enums/organization_type.dart';

class OrganizationListingRequest {
  const OrganizationListingRequest({
    required this.limit,
    this.cursor,
    this.type = OrganizationType.seller,
    this.query,
  }) : assert(limit >= 1 && limit <= 100);

  final int limit;
  final String? cursor;
  final OrganizationType type;
  final String? query;

  Map<String, dynamic> toQueryParameters() => {
    'limit': limit,
    if (cursor != null && cursor!.isNotEmpty) 'cursor': cursor,
    'type': type.apiValue,
    if (query != null && query!.trim().isNotEmpty) 'q': query!.trim(),
  };
}
