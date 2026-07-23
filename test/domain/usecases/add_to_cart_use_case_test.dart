import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/core/enums/add_to_cart_result.dart';
import 'package:ordaraa/data/models/product_json.dart';
import 'package:ordaraa/domain/entities/product.dart';
import 'package:ordaraa/domain/stores/cart_store.dart';
import 'package:ordaraa/domain/usecases/add_to_cart_use_case.dart';

void main() {
  late CartStore cartStore;
  late AddToCartUseCase useCase;

  setUp(() {
    cartStore = CartStore();
    useCase = AddToCartUseCase(cartStore);
  });

  test('first product establishes the cart supplier and minimum quantity', () {
    final result = useCase.execute(product: _product());

    expect(result, AddToCartResult.added);
    expect(cartStore.state.seller?.id, 'seller-a');
    expect(cartStore.state.items.single.quantity, 2);
  });

  test('same product increments its existing cart line', () {
    final product = _product();

    useCase.execute(product: product);
    final result = useCase.execute(product: product);

    expect(result, AddToCartResult.updated);
    expect(cartStore.state.items, hasLength(1));
    expect(cartStore.state.items.single.quantity, 4);
  });

  test('different supplier is rejected without changing the cart', () {
    useCase.execute(product: _product());

    final result = useCase.execute(
      product: _product(id: 'product-b', sellerId: 'seller-b'),
    );

    expect(result, AddToCartResult.differentSupplier);
    expect(cartStore.state.items, hasLength(1));
    expect(cartStore.state.seller?.id, 'seller-a');
  });

  test('unavailable product is not added', () {
    final result = useCase.execute(
      product: _product(stockStatus: 'OUT_OF_STOCK'),
    );

    expect(result, AddToCartResult.unavailable);
    expect(cartStore.state.isEmpty, isTrue);
  });
}

Product _product({
  String id = 'product-a',
  String sellerId = 'seller-a',
  String stockStatus = 'IN_STOCK',
}) {
  return ProductJson.fromJson({
    'id': id,
    'publicCode': 'LST-TEST',
    'seller': {
      'id': sellerId,
      'publicCode': 'ORG-TEST',
      'name': 'Test Supplier',
      'type': 'SELLER',
      'logo': null,
      'market': {
        'id': 'market-a',
        'code': 'au',
        'name': 'Australia',
        'countryCode': 'AU',
        'currency': 'AUD',
        'timezone': 'Australia/Sydney',
        'language': 'en-AU',
        'status': 'ACTIVE',
      },
      'status': 'ACTIVE',
      'verified': true,
      'legalName': null,
      'registrationNumber': null,
      'taxNumber': null,
      'contactName': null,
      'contactEmail': null,
      'contactPhone': null,
      'defaultPaymentTerms': 'NET_14',
      'createdAt': '2026-07-21T14:51:27.117Z',
    },
    'variant': {
      'id': 'variant-a',
      'label': 'Test product',
      'size': null,
      'grade': null,
      'form': null,
      'preservation': null,
      'originCountryCode': null,
      'baseUnit': {
        'id': 'unit-kg',
        'code': 'kg',
        'label': 'Kilogram',
        'kind': 'WEIGHT',
        'decimalPlaces': 2,
        'status': 'ACTIVE',
      },
    },
    'sellerSku': null,
    'titleOverride': null,
    'descriptionOverride': null,
    'images': <Map<String, dynamic>>[],
    'price': {'amount': '10', 'currency': 'AUD', 'formatted': 'A\$10.00'},
    'priceUnit': {
      'id': 'unit-case',
      'code': 'case',
      'label': 'Case',
      'kind': 'PACK',
      'decimalPlaces': 0,
      'status': 'ACTIVE',
    },
    'minimumOrderQuantity': '2',
    'quantityIncrement': '1',
    'leadTimeHours': null,
    'deliveryTerms': null,
    'status': 'ACTIVE',
    'createdAt': '2026-07-21T14:51:29.289Z',
    'stockStatus': stockStatus,
  }).toDomain();
}
