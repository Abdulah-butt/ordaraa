import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import 'otp_verification_cubit.dart';
import 'otp_verification_initial_params.dart';
import 'otp_verification_state.dart';
import 'widgets/otp_verification_content.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/otp-verification';

  final OtpVerificationCubit cubit;
  final OtpVerificationInitialParams initialParams;

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  OtpVerificationCubit get cubit => widget.cubit;

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
    return BlocBuilder<OtpVerificationCubit, OtpVerificationState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: context.colorTheme.surface,
          body: OtpVerificationContent(cubit: cubit, state: state),
        );
      },
    );
  }
}
