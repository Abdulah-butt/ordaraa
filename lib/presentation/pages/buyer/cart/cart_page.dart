import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_cubit.dart';
import 'cart_initial_params.dart';
import 'cart_state.dart';
import 'widgets/cart_content.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.cubit, required this.initialParams});

  static const path = '/buyer/cart';

  final CartCubit cubit;
  final CartInitialParams initialParams;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          body: CartContent(
            state: state,
            onBack: cubit.navigator.goBack,
            onBrowse: cubit.navigator.browseProducts,
            onClear: cubit.clearCart,
            onIncrement: cubit.increment,
            onDecrement: cubit.decrement,
            onRemove: cubit.remove,
            onProductTap: cubit.navigator.openProduct,
            onSellerTap: cubit.navigator.openSeller,
            onCheckout: cubit.checkout,
          ),
        );
      },
    );
  }
}
