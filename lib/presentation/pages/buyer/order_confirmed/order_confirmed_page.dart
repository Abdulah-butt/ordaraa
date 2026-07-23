import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_confirmed_cubit.dart';
import 'order_confirmed_initial_params.dart';
import 'order_confirmed_state.dart';
import 'widgets/order_confirmed_content.dart';

class OrderConfirmedPage extends StatefulWidget {
  const OrderConfirmedPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/buyer/order-confirmed';

  final OrderConfirmedCubit cubit;
  final OrderConfirmedInitialParams initialParams;

  @override
  State<OrderConfirmedPage> createState() => _OrderConfirmedPageState();
}

class _OrderConfirmedPageState extends State<OrderConfirmedPage> {
  OrderConfirmedCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderConfirmedCubit, OrderConfirmedState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          body: OrderConfirmedContent(
            state: state,
            onRetry: cubit.retry,
            onViewOrder: cubit.navigator.viewOrders,
            onContinueShopping: cubit.navigator.continueShopping,
          ),
        );
      },
    );
  }
}
