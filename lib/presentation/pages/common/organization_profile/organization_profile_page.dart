import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../widgets/buyer_detail_app_bar.dart';
import '../../../widgets/custom_button.dart';
import 'organization_profile_cubit.dart';
import 'organization_profile_initial_params.dart';
import 'organization_profile_state.dart';
import 'widgets/organization_profile_content.dart';
import 'widgets/organization_profile_loading.dart';

class OrganizationProfilePage extends StatefulWidget {
  const OrganizationProfilePage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/buyer/organization-profile';

  final OrganizationProfileCubit cubit;
  final OrganizationProfileInitialParams initialParams;

  @override
  State<OrganizationProfilePage> createState() =>
      _OrganizationProfilePageState();
}

class _OrganizationProfilePageState extends State<OrganizationProfilePage> {
  OrganizationProfileCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.prepareForDisplay();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) cubit.onInit(widget.initialParams);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizationProfileCubit, OrganizationProfileState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                BuyerDetailAppBar(
                  title: 'Organization profile',
                  onBack: cubit.navigator.goBack,
                ),
                Expanded(child: _body(state)),
                if (state.organization != null)
                  SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorTheme.surface,
                        border: Border(
                          top: BorderSide(
                            color: context.colorTheme.outlineVariant,
                          ),
                        ),
                      ),
                      child: CustomButton(
                        text: 'Save changes',
                        isLoading: state.saving,
                        onTap: cubit.save,
                        leadingIcon: const Icon(Icons.check_rounded, size: 19),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _body(OrganizationProfileState state) {
    if (state.loading && state.organization == null) {
      return const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: OrganizationProfileLoading(),
      );
    }
    if (state.organization == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: 40,
                color: context.colorTheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'We could not load your organization profile.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              CustomButton(
                width: 150,
                height: 48,
                text: 'Try again',
                onTap: cubit.retry,
              ),
            ],
          ),
        ),
      );
    }
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      child: OrganizationProfileContent(cubit: cubit, state: state),
    );
  }
}
