import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import 'phone_login_cubit.dart';
import 'phone_login_initial_params.dart';
import 'phone_login_state.dart';
import 'widgets/phone_login_content.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/phone-login';

  final PhoneLoginCubit cubit;
  final PhoneLoginInitialParams initialParams;

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  PhoneLoginCubit get cubit => widget.cubit;

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
    return BlocBuilder<PhoneLoginCubit, PhoneLoginState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: context.colorTheme.surface,
          body: PhoneLoginContent(cubit: cubit, state: state),
        );
      },
    );
  }
}
