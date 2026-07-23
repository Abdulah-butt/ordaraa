import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../core/extensions/add_to_cart_result_extension.dart';
import '../../../../domain/usecases/get_product_by_id_use_case.dart';
import '../../../../domain/usecases/add_to_cart_use_case.dart';
import 'product_detail_initial_params.dart';
import 'product_detail_navigator.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({
    required this.navigator,
    required this.getProductByIdUseCase,
    required this.addToCartUseCase,
    required this.snackBar,
  }) : super(ProductDetailState.initial());

  final ProductDetailNavigator navigator;
  final GetProductByIdUseCase getProductByIdUseCase;
  final AddToCartUseCase addToCartUseCase;
  final AppSnackBar snackBar;
  String? _productId;

  Future<void> onInit(ProductDetailInitialParams initialParams) async {
    if (initialParams.productId.isEmpty) {
      emit(state.copyWith(errorMessage: () => 'Product ID is missing.'));
      return;
    }
    if (_productId == initialParams.productId && state.product != null) return;
    _productId = initialParams.productId;
    await _load();
  }

  Future<void> refresh() => _load(preserveProduct: true);

  Future<void> retry() => _load();

  Future<void> _load({bool preserveProduct = false}) async {
    final productId = _productId;
    if (productId == null || state.loading) return;
    emit(
      state.copyWith(
        product: preserveProduct ? null : () => null,
        loading: true,
        errorMessage: () => null,
      ),
    );
    try {
      final product = await getProductByIdUseCase.execute(id: productId);
      final minimum = (num.tryParse(product.minimumOrderQuantity) ?? 1).ceil();
      emit(state.copyWith(product: () => product, quantity: minimum));
    } catch (error) {
      emit(state.copyWith(errorMessage: () => error.toString()));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  void incrementQuantity() {
    final increment =
        (num.tryParse(state.product?.quantityIncrement ?? '1') ?? 1).ceil();
    emit(state.copyWith(quantity: state.quantity + increment));
  }

  void decrementQuantity() {
    final product = state.product;
    if (product == null) return;
    final minimum = (num.tryParse(product.minimumOrderQuantity) ?? 1).ceil();
    final increment = (num.tryParse(product.quantityIncrement) ?? 1).ceil();
    if (state.quantity <= minimum) return;
    emit(
      state.copyWith(
        quantity: (state.quantity - increment).clamp(minimum, 1 << 31).toInt(),
      ),
    );
  }

  void openSeller() {
    final seller = state.product?.seller;
    if (seller != null) navigator.openSeller(seller.id);
  }

  void addToCart() {
    final product = state.product;
    if (product == null) return;
    addToCartUseCase
        .execute(product: product, quantity: state.quantity)
        .showFeedback(snackBar);
  }

  void openCart() => navigator.openCart();
}
