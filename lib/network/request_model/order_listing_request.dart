import '../../core/enums/order_list_role.dart';
import '../../core/enums/order_list_status.dart';

class OrderListingRequest {
  const OrderListingRequest({
    required this.limit,
    required this.role,
    this.cursor,
    this.status,
  }) : assert(limit >= 1 && limit <= 100);

  final int limit;
  final String? cursor;
  final OrderListRole role;
  final OrderListStatus? status;

  Map<String, dynamic> toQueryParameters() => {
    'limit': limit,
    'as': role.apiValue,
    if (status != null) 'status': status!.apiValue,
    if (cursor != null && cursor!.isNotEmpty) 'cursor': cursor,
  };
}
