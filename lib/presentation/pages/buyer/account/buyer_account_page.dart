import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'buyer_account_cubit.dart';
import 'buyer_account_initial_params.dart';
import 'buyer_account_state.dart';
import 'widgets/buyer_account_content.dart';

class BuyerAccountPage extends StatefulWidget {
  const BuyerAccountPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/buyer/account';

  final BuyerAccountCubit cubit;
  final BuyerAccountInitialParams initialParams;

  @override
  State<BuyerAccountPage> createState() => _BuyerAccountPageState();
}

class _BuyerAccountPageState extends State<BuyerAccountPage> {
  BuyerAccountCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyerAccountCubit, BuyerAccountState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          body: BuyerAccountContent(
            state: state,
            onLogout: cubit.confirmLogout,
            onDeleteAccount: cubit.confirmDeleteAccount,
          ),
        );
      },
    );
  }
}
