import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/theme_extension.dart';
import 'splash_cubit.dart';
import 'splash_initial_params.dart';
import 'splash_state.dart';
import 'widgets/splash_content.dart';

class SplashPage extends StatefulWidget {
  final SplashCubit cubit;
  final SplashInitialParams initialParams;

  static const path = '/splash';

  const SplashPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  @override
  State<SplashPage> createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  SplashCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashCubit, SplashState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colorTheme.surface,
          body: const SplashContent(),
        );
      },
    );
  }
}
