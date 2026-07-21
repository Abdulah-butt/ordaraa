import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/theme_extension.dart';
import 'choose_role_cubit.dart';
import 'choose_role_initial_params.dart';
import 'choose_role_state.dart';
import 'widgets/choose_role_content.dart';

class ChooseRolePage extends StatefulWidget {
  const ChooseRolePage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/choose-role';

  final ChooseRoleCubit cubit;
  final ChooseRoleInitialParams initialParams;

  @override
  State<ChooseRolePage> createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage> {
  ChooseRoleCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseRoleCubit, ChooseRoleState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colorTheme.surface,
          body: ChooseRoleContent(
            state: state,
            onRoleSelected: cubit.onRoleSelected,
          ),
        );
      },
    );
  }
}
