import '../../core/enums/organization_type.dart';

class OrganizationListingRequest {
  const OrganizationListingRequest({
    required this.limit,
    required this.offset,
    this.type = OrganizationType.seller,
    this.query,
  }) : assert(limit >= 1 && limit <= 100),
       assert(offset >= 0 && offset <= 10000);

  final int limit;
  final int offset;
  final OrganizationType type;
  final String? query;

  Map<String, dynamic> toQueryParameters() => {
    'limit': limit,
    'offset': offset,
    'type': type.apiValue,
    if (query != null && query!.trim().isNotEmpty) 'q': query!.trim(),
  };
}
