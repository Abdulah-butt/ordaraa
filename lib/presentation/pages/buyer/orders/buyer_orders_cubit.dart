import 'package:flutter_bloc/flutter_bloc.dart';

import 'buyer_orders_initial_params.dart';
import 'buyer_orders_navigator.dart';
import 'buyer_orders_state.dart';

class BuyerOrdersCubit extends Cubit<BuyerOrdersState> {
  BuyerOrdersCubit({required this.navigator})
    : super(BuyerOrdersState.initial());

  final BuyerOrdersNavigator navigator;

  void onInit(BuyerOrdersInitialParams initialParams) {}
}
