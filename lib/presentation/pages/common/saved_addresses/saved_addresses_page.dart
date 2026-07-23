import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../widgets/app_pull_to_refresh.dart';
import '../../../widgets/buyer_detail_app_bar.dart';
import '../../../widgets/custom_button.dart';
import 'saved_addresses_cubit.dart';
import 'saved_addresses_initial_params.dart';
import 'saved_addresses_state.dart';
import 'widgets/saved_address_card.dart';
import 'widgets/saved_addresses_loading.dart';

class SavedAddressesPage extends StatefulWidget {
  const SavedAddressesPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/common/saved-addresses';

  final SavedAddressesCubit cubit;
  final SavedAddressesInitialParams initialParams;

  @override
  State<SavedAddressesPage> createState() => _SavedAddressesPageState();
}

class _SavedAddressesPageState extends State<SavedAddressesPage> {
  SavedAddressesCubit get cubit => widget.cubit;

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
    return BlocBuilder<SavedAddressesCubit, SavedAddressesState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                BuyerDetailAppBar(
                  title: 'Saved addresses',
                  onBack: cubit.navigator.goBack,
                ),
                Expanded(
                  child: AppPullToRefresh(
                    onRefresh: cubit.refresh,
                    child: _content(context, state),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _content(BuildContext context, SavedAddressesState state) {
    if (state.loading && state.addresses.isEmpty) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: SavedAddressesLoading(),
      );
    }
    if (state.addresses.isEmpty && state.errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.xxl),
        children: [
          const SizedBox(height: 120),
          Icon(
            Icons.cloud_off_outlined,
            size: 42,
            color: context.colorTheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'We could not load your saved addresses.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: CustomButton(
              width: 150,
              height: 48,
              text: 'Try again',
              onTap: cubit.retry,
            ),
          ),
        ],
      );
    }
    if (state.addresses.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.xxl),
        children: [
          const SizedBox(height: 120),
          Icon(
            Icons.location_off_outlined,
            size: 44,
            color: context.colorTheme.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No saved addresses yet',
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Your organization’s delivery, billing, and business addresses will appear here.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorTheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      itemCount: state.addresses.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return SavedAddressCard(address: state.addresses[index]);
      },
    );
  }
}
