import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'buyer_search_cubit.dart';
import 'buyer_search_initial_params.dart';
import 'buyer_search_state.dart';
import 'widgets/buyer_search_content.dart';

class BuyerSearchPage extends StatefulWidget {
  const BuyerSearchPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/buyer/search';

  final BuyerSearchCubit cubit;
  final BuyerSearchInitialParams initialParams;

  @override
  State<BuyerSearchPage> createState() => _BuyerSearchPageState();
}

class _BuyerSearchPageState extends State<BuyerSearchPage> {
  BuyerSearchCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  void dispose() {
    cubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyerSearchCubit, BuyerSearchState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          body: BuyerSearchContent(cubit: cubit, state: state),
        );
      },
    );
  }
}
