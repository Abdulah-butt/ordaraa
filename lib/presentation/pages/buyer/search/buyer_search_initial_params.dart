import '../../../../core/navigation/route_params.dart';

class BuyerSearchInitialParams extends RouteParams {
  const BuyerSearchInitialParams({
    this.categorySlug,
    this.showSuppliers = false,
  });

  final String? categorySlug;
  final bool showSuppliers;

  @override
  Map<String, dynamic> toMap() => {
    if (categorySlug != null) 'categorySlug': categorySlug,
    if (showSuppliers) 'showSuppliers': 'true',
  };

  static BuyerSearchInitialParams fromMap(Map<String, dynamic> map) {
    return BuyerSearchInitialParams(
      categorySlug: map['categorySlug'] as String?,
      showSuppliers: map['showSuppliers'] == 'true',
    );
  }
}
