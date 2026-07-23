import '../../core/enums/listing_status.dart';
import '../../core/enums/stock_status.dart';
import '../../domain/entities/product.dart';
import 'image_resource_json.dart';
import 'money_json.dart';
import 'organization_json.dart';
import 'product_variant_json.dart';
import 'unit_json.dart';

class ProductJson {
  ProductJson({
    required this.id,
    required this.publicCode,
    required this.seller,
    required this.variant,
    required this.sellerSku,
    required this.titleOverride,
    required this.descriptionOverride,
    required List<ImageResourceJson> images,
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
  final OrganizationJson seller;
  final ProductVariantJson variant;
  final String? sellerSku;
  final String? titleOverride;
  final String? descriptionOverride;
  final List<ImageResourceJson> images;
  final MoneyJson price;
  final UnitJson priceUnit;
  final String minimumOrderQuantity;
  final String quantityIncrement;
  final int? leadTimeHours;
  final String? deliveryTerms;
  final ListingStatus status;
  final DateTime createdAt;
  final StockStatus stockStatus;

  factory ProductJson.fromJson(Map<String, dynamic> json) {
    return ProductJson(
      id: json['id'] as String,
      publicCode: json['publicCode'] as String,
      seller: OrganizationJson.fromJson(json['seller'] as Map<String, dynamic>),
      variant: ProductVariantJson.fromJson(
        json['variant'] as Map<String, dynamic>,
      ),
      sellerSku: json['sellerSku'] as String?,
      titleOverride: json['titleOverride'] as String?,
      descriptionOverride: json['descriptionOverride'] as String?,
      images: (json['images'] as List<dynamic>)
          .map(
            (image) =>
                ImageResourceJson.fromJson(image as Map<String, dynamic>),
          )
          .toList(growable: false),
      price: MoneyJson.fromJson(json['price'] as Map<String, dynamic>),
      priceUnit: UnitJson.fromJson(json['priceUnit'] as Map<String, dynamic>),
      minimumOrderQuantity: json['minimumOrderQuantity'] as String,
      quantityIncrement: json['quantityIncrement'] as String,
      leadTimeHours: json['leadTimeHours'] as int?,
      deliveryTerms: json['deliveryTerms'] as String?,
      status: ListingStatus.fromApiValue(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      stockStatus: StockStatus.fromApiValue(json['stockStatus'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'publicCode': publicCode,
    'seller': seller.toJson(),
    'variant': variant.toJson(),
    'sellerSku': sellerSku,
    'titleOverride': titleOverride,
    'descriptionOverride': descriptionOverride,
    'images': images.map((image) => image.toJson()).toList(growable: false),
    'price': price.toJson(),
    'priceUnit': priceUnit.toJson(),
    'minimumOrderQuantity': minimumOrderQuantity,
    'quantityIncrement': quantityIncrement,
    'leadTimeHours': leadTimeHours,
    'deliveryTerms': deliveryTerms,
    'status': status.apiValue,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'stockStatus': stockStatus.apiValue,
  };

  Product toDomain() {
    return Product(
      id: id,
      publicCode: publicCode,
      seller: seller.toDomain(),
      variant: variant.toDomain(),
      sellerSku: sellerSku,
      titleOverride: titleOverride,
      descriptionOverride: descriptionOverride,
      images: images.map((image) => image.toDomain()).toList(growable: false),
      price: price.toDomain(),
      priceUnit: priceUnit.toDomain(),
      minimumOrderQuantity: minimumOrderQuantity,
      quantityIncrement: quantityIncrement,
      leadTimeHours: leadTimeHours,
      deliveryTerms: deliveryTerms,
      status: status,
      createdAt: createdAt,
      stockStatus: stockStatus,
    );
  }
}
