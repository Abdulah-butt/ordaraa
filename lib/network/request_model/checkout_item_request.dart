import 'package:equatable/equatable.dart';

class CheckoutItemRequest extends Equatable {
  const CheckoutItemRequest({required this.listingId, required this.quantity});

  final String listingId;
  final String quantity;

  Map<String, dynamic> toJson() => {
    'listingId': listingId,
    'quantity': quantity,
  };

  @override
  List<Object?> get props => [listingId, quantity];
}
