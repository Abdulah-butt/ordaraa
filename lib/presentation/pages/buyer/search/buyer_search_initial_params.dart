import '../../../../core/navigation/route_params.dart';

class BuyerSearchInitialParams extends RouteParams {
  const BuyerSearchInitialParams({this.categorySlug});

  final String? categorySlug;

  @override
  Map<String, dynamic> toMap() => {
    if (categorySlug != null) 'categorySlug': categorySlug,
  };

  static BuyerSearchInitialParams fromMap(Map<String, dynamic> map) {
    return BuyerSearchInitialParams(
      categorySlug: map['categorySlug'] as String?,
    );
  }
}
