import 'package:equatable/equatable.dart';

import '../../core/enums/listing_status.dart';
import '../../core/enums/stock_status.dart';
import 'image_resource.dart';
import 'money.dart';
import 'organization.dart';
import 'product_variant.dart';
import 'unit.dart';

class Product extends Equatable {
  Product({
    required this.id,
    required this.publicCode,
    required this.seller,
    required this.variant,
    required this.sellerSku,
    required this.titleOverride,
    required this.descriptionOverride,
    required List<ImageResource> images,
    required this.price,
    required this.priceUnit,
    required this.minimumOrderQuantity,
    required this.quantityIncrement,
    required this.leadTimeHours,
    required this.deliveryTerms,
    required this.status,
    required this.createdAt,
    required this.stockStatus,
  }) : images = List.unmodifiable(images);

  final String id;
  final String publicCode;
  final Organization seller;
  final ProductVariant variant;
  final String? sellerSku;
  final String? titleOverride;
  final String? descriptionOverride;
  final List<ImageResource> images;
  final Money price;
  final Unit priceUnit;
  final String minimumOrderQuantity;
  final String quantityIncrement;
  final int? leadTimeHours;
  final String? deliveryTerms;
  final ListingStatus status;
  final DateTime createdAt;
  final StockStatus stockStatus;

  Product copyWith({
    String? id,
    String? publicCode,
    Organization? seller,
    ProductVariant? variant,
    String? Function()? sellerSku,
    String? Function()? titleOverride,
    String? Function()? descriptionOverride,
    List<ImageResource>? images,
    Money? price,
    Unit? priceUnit,
    String? minimumOrderQuantity,
    String? quantityIncrement,
    int? Function()? leadTimeHours,
    String? Function()? deliveryTerms,
    ListingStatus? status,
    DateTime? createdAt,
    StockStatus? stockStatus,
  }) {
    return Product(
      id: id ?? this.id,
      publicCode: publicCode ?? this.publicCode,
      seller: seller ?? this.seller,
      variant: variant ?? this.variant,
      sellerSku: sellerSku == null ? this.sellerSku : sellerSku(),
      titleOverride: titleOverride == null
          ? this.titleOverride
          : titleOverride(),
      descriptionOverride: descriptionOverride == null
          ? this.descriptionOverride
          : descriptionOverride(),
      images: images ?? this.images,
      price: price ?? this.price,
      priceUnit: priceUnit ?? this.priceUnit,
      minimumOrderQuantity: minimumOrderQuantity ?? this.minimumOrderQuantity,
      quantityIncrement: quantityIncrement ?? this.quantityIncrement,
      leadTimeHours: leadTimeHours == null
          ? this.leadTimeHours
          : leadTimeHours(),
      deliveryTerms: deliveryTerms == null
          ? this.deliveryTerms
          : deliveryTerms(),
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      stockStatus: stockStatus ?? this.stockStatus,
    );
  }

  @override
  List<Object?> get props => [
    id,
    publicCode,
    seller,
    variant,
    sellerSku,
    titleOverride,
    descriptionOverride,
    images,
    price,
    priceUnit,
    minimumOrderQuantity,
    quantityIncrement,
    leadTimeHours,
    deliveryTerms,
    status,
    createdAt,
    stockStatus,
  ];
}
