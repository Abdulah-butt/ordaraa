import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../widgets/app_pull_to_refresh.dart';
import '../../../widgets/buyer_detail_app_bar.dart';
import 'order_detail_cubit.dart';
import 'order_detail_initial_params.dart';
import 'order_detail_state.dart';
import 'widgets/order_detail_action_bar.dart';
import 'widgets/order_detail_content.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/buyer/order-detail';

  final OrderDetailCubit cubit;
  final OrderDetailInitialParams initialParams;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderDetailCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailCubit, OrderDetailState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colorTheme.surface,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                BuyerDetailAppBar(
                  title: state.order == null
                      ? 'Order details'
                      : 'Order ${state.order!.publicNumber}',
                  onBack: cubit.navigator.goBack,
                ),
                Expanded(
                  child: AppPullToRefresh(
                    onRefresh: cubit.refresh,
                    child: OrderDetailContent(
                      state: state,
                      onRetry: cubit.retry,
                      onSellerTap: cubit.openSeller,
                    ),
                  ),
                ),
                if (state.order != null)
                  OrderDetailActionBar(onContactSupplier: cubit.contactSeller),
              ],
            ),
          ),
        );
      },
    );
  }
}
