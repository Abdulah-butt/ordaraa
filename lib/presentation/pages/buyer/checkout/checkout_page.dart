import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'checkout_cubit.dart';
import 'checkout_initial_params.dart';
import 'checkout_state.dart';
import 'widgets/checkout_content.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/buyer/checkout';

  final CheckoutCubit cubit;
  final CheckoutInitialParams initialParams;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  CheckoutCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          body: CheckoutContent(
            state: state,
            cart: cubit.cartStore.state,
            notesController: cubit.notesController,
            onBack: cubit.navigator.goBack,
            onAddressTap: cubit.openAddressPicker,
            onRetry: cubit.retry,
            onPlaceOrder: cubit.placeOrder,
          ),
        );
      },
    );
  }
}
