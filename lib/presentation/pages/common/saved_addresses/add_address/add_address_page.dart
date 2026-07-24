import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../widgets/buyer_detail_app_bar.dart';
import '../../../../widgets/custom_button.dart';
import 'add_address_cubit.dart';
import 'add_address_initial_params.dart';
import 'add_address_state.dart';
import 'widgets/add_address_form.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/common/saved-addresses/add';

  final AddAddressCubit cubit;
  final AddAddressInitialParams initialParams;

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  AddAddressCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddAddressCubit, AddAddressState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                BuyerDetailAppBar(
                  title: state.isEditing ? 'Edit address' : 'Add address',
                  onBack: cubit.navigator.goBack,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.xxl,
                    ),
                    child: AddAddressForm(cubit: cubit, state: state),
                  ),
                ),
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
                      text: state.isEditing ? 'Save changes' : 'Save address',
                      isLoading: state.submitting,
                      onTap: cubit.submit,
                      leadingIcon: const Icon(
                        Icons.add_location_alt_outlined,
                        size: 19,
                      ),
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
}
