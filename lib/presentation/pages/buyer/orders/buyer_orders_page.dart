import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import 'buyer_orders_cubit.dart';
import 'buyer_orders_initial_params.dart';
import 'buyer_orders_state.dart';
import 'widgets/buyer_orders_content.dart';

class BuyerOrdersPage extends StatefulWidget {
  const BuyerOrdersPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/buyer/orders';

  final BuyerOrdersCubit cubit;
  final BuyerOrdersInitialParams initialParams;

  @override
  State<BuyerOrdersPage> createState() => _BuyerOrdersPageState();
}

class _BuyerOrdersPageState extends State<BuyerOrdersPage> {
  BuyerOrdersCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyerOrdersCubit, BuyerOrdersState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colorTheme.surface,
          body: BuyerOrdersContent(
            state: state,
            scrollController: cubit.scrollController,
            onTabSelected: cubit.selectStatus,
            onRefresh: cubit.refresh,
            onRetry: cubit.retryInitial,
            onLoadMoreRetry: cubit.loadMore,
            onOrderSelected: cubit.openOrder,
          ),
        );
      },
    );
  }
}
