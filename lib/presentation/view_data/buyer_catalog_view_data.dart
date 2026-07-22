import 'package:equatable/equatable.dart';

enum BuyerProductAvailability { available, lowStock, outOfStock }

class BuyerProductViewData extends Equatable {
  const BuyerProductViewData({
    required this.name,
    required this.imageAsset,
    required this.availability,
    required this.supplier,
    required this.packaging,
    required this.price,
  });

  final String name;
  final String imageAsset;
  final BuyerProductAvailability availability;
  final String supplier;
  final String packaging;
  final String price;

  bool get isAvailable => availability != BuyerProductAvailability.outOfStock;

  @override
  List<Object?> get props => [
    name,
    imageAsset,
    availability,
    supplier,
    packaging,
    price,
  ];
}

class BuyerSupplierViewData extends Equatable {
  const BuyerSupplierViewData({
    required this.name,
    required this.serviceArea,
    required this.deliveryDetails,
    required this.catalogSummary,
    this.status = 'Verified',
  });

  final String name;
  final String status;
  final String serviceArea;
  final String deliveryDetails;
  final String catalogSummary;

  @override
  List<Object?> get props => [
    name,
    status,
    serviceArea,
    deliveryDetails,
    catalogSummary,
  ];
}
