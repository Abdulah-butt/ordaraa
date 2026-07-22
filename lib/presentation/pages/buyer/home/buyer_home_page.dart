import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'buyer_home_cubit.dart';
import 'buyer_home_initial_params.dart';
import 'buyer_home_state.dart';
import 'widgets/buyer_home_content.dart';

class BuyerHomePage extends StatefulWidget {
  const BuyerHomePage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/buyer/home';

  final BuyerHomeCubit cubit;
  final BuyerHomeInitialParams initialParams;

  @override
  State<BuyerHomePage> createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  BuyerHomeCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyerHomeCubit, BuyerHomeState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          body: BuyerHomeContent(
            state: state,
            categoryStore: cubit.categoryStore,
            onCategorySelected: cubit.selectCategory,
            onViewAllCategories: cubit.viewAllCategories,
          ),
        );
      },
    );
  }
}
